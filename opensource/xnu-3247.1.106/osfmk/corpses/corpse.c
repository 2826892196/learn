/*
 * Copyright (c) 2012-2013, 2015 Apple Inc. All rights reserved.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. The rights granted to you under the License
 * may not be used to create, or enable the creation or redistribution of,
 * unlawful or unlicensed copies of an Apple operating system, or to
 * circumvent, violate, or enable the circumvention or violation of, any
 * terms of an Apple operating system software license agreement.
 *
 * Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_END@
 */


/*
 * Corpses Overview
 * ================
 * 
 * A corpse is a state of process that is past the point of its death. This means that process has
 * completed all its termination operations like releasing file descriptors, mach ports, sockets and
 * other constructs used to identify a process. For all the processes this mimics the behavior as if
 * the process has died and no longer available by any means.
 * 
 * Why do we need Corpses?
 * -----------------------
 * For crash inspection we need to inspect the state and data that is associated with process so that
 * crash reporting infrastructure can build backtraces, find leaks etc. For example a crash
 * 
 * Corpses functionality in kernel
 * ===============================
 * The corpse functionality is an extension of existing exception reporting mechanisms we have. The
 * exception_triage calls will try to deliver the first round of exceptions allowing
 * task/debugger/ReportCrash/launchd level exception handlers to  respond to exception. If even after
 * notification the exception is not handled, then the process begins the death operations and during
 * proc_prepareexit, we decide to create a corpse for inspection. Following is a sample run through
 * of events and data shuffling that happens when corpses is enabled.
 * 
 *   * a process causes an exception during normal execution of threads.
 *   * The exception generated by either mach(e.g GUARDED_MARCHPORT) or bsd(eg SIGABORT, GUARDED_FD
 *     etc) side is passed through the exception_triage() function to follow the thread -> task -> host
 *     level exception handling system. This set of steps are same as before and allow for existing
 *     crash reporting systems (both internal and 3rd party) to catch and create reports as required.
 *   * If above exception handling returns failed (when nobody handles the notification), then the
 *     proc_prepareexit path has logic to decide to create corpse.
 *   * The task_mark_corpse function allocates userspace vm memory and attaches the information
 *     kcdata_descriptor_t to task->corpse_info field of task.
 *     - All the task's threads are marked with the "inspection" flag which signals the termination
 *       daemon to not reap them but hold until they are being inspected.
 *     - task flags t_flags reflect the corpse bit and also a PENDING_CORPSE bit. PENDING_CORPSE
 *       prevents task_terminate from stripping important data from task.
 *     - It marks all the threads to terminate and return to AST for termination.
 *     - The allocation logic takes into account the rate limiting policy of allowing only
 *       TOTAL_CORPSES_ALLOWED in flight.
 *   * The proc exit threads continues and collects required information in the allocated vm region.
 *     Once complete it marks itself for termination.
 *   * In the thread_terminate_self(), the last thread to enter will do a call to proc_exit().
 *     Following this is a check to see if task is marked for corpse notification and will
 *     invoke the the task_deliver_crash_notification().
 *   * Once EXC_CORPSE_NOTIFY is delivered, it removes the PENDING_CORPSE flag from task (and
 *     inspection flag from all its threads) and allows task_terminate to go ahead and continue
 *     the mach task termination process.
 *   * ASIDE: The rest of the threads that are reaching the thread_terminate_daemon() with the
 *     inspection flag set are just bounced to another holding queue (crashed_threads_queue).
 *     Only after the corpse notification these are pulled out from holding queue and enqueued
 *     back to termination queue
 * 
 * 
 * Corpse info format
 * ==================
 * The kernel (task_mark_corpse()) makes a vm allocation in the dead task's vm space (with tag
 *     VM_MEMORY_CORPSEINFO (80)). Within this memory all corpse information is saved by various
 *     subsystems like
 *   * bsd proc exit path may write down pid, parent pid, number of file descriptors etc
 *   * mach side may append data regarding ledger usage, memory stats etc
 * See detailed info about the memory structure and format in kern_cdata.h documentation.
 * 
 * Configuring Corpses functionality
 * =================================
 *   boot-arg: -no_corpses disables the corpse generation. This can be added/removed without affecting
 *     any other subsystem.
 *   TOTAL_CORPSES_ALLOWED : (recompilation required) - Changing this number allows for controlling
 *     the number of corpse instances to be held for inspection before allowing memory to be reclaimed
 *     by system.
 *   CORPSEINFO_ALLOCATION_SIZE: is the default size of vm allocation. If in future there is much more
 *     data to be put in, then please re-tune this parameter.
 * 
 * Debugging/Visibility
 * ====================
 *   * lldbmacros for thread and task summary are updated to show "C" flag for corpse task/threads.
 *   * there are macros to see list of threads in termination queue (dumpthread_terminate_queue)
 *     and holding queue (dumpcrashed_thread_queue).
 *   * In case of corpse creation is disabled of ignored then the system log is updated with
 *     printf data with reason.
 * 
 * Limitations of Corpses
 * ======================
 *   With holding off memory for inspection, it creates vm pressure which might not be desirable
 *   on low memory devices. There are limits to max corpses being inspected at a time which is
 *   marked by TOTAL_CORPSES_ALLOWED.
 * 
 */


#include <kern/assert.h>
#include <mach/mach_types.h>
#include <mach/boolean.h>
#include <mach/vm_param.h>
#include <kern/kern_types.h>
#include <kern/mach_param.h>
#include <kern/thread.h>
#include <kern/task.h>
#include <corpses/task_corpse.h>
#include <kern/kalloc.h>
#include <kern/kern_cdata.h>
#include <mach/mach_vm.h>

unsigned long  total_corpses_count = 0;
unsigned long  total_corpses_created = 0;
boolean_t corpse_enabled_config = TRUE;

kcdata_descriptor_t task_get_corpseinfo(task_t task);
kcdata_descriptor_t task_crashinfo_alloc_init(mach_vm_address_t crash_data_p, unsigned size);
kern_return_t task_crashinfo_destroy(kcdata_descriptor_t data);
static kern_return_t task_crashinfo_get_ref();
static kern_return_t task_crashinfo_release_ref();



void corpses_init(){
	char temp_buf[20];
	if (PE_parse_boot_argn("-no_corpses", temp_buf, sizeof(temp_buf))) {
		corpse_enabled_config = FALSE;
	}
}

/*
 * Routine: corpses_enabled
 * returns FALSE if not enabled
 */
boolean_t corpses_enabled()
{
	return corpse_enabled_config;
}

/*
 * Routine: task_crashinfo_get_ref()
 *          Grab a slot at creating a corpse.
 * Returns: KERN_SUCCESS if the policy allows for creating a corpse.
 */
kern_return_t task_crashinfo_get_ref()
{
	unsigned long counter = total_corpses_count;
	counter = OSIncrementAtomic((SInt32 *)&total_corpses_count);
	if (counter >= TOTAL_CORPSES_ALLOWED) {
		OSDecrementAtomic((SInt32 *)&total_corpses_count);
		return KERN_RESOURCE_SHORTAGE;
	}
	OSIncrementAtomicLong((volatile long *)&total_corpses_created);
	return KERN_SUCCESS;
}

/*
 * Routine: task_crashinfo_release_ref
 *          release the slot for corpse being used.
 */
kern_return_t task_crashinfo_release_ref()
{
	unsigned long __assert_only counter;
	counter =	OSDecrementAtomic((SInt32 *)&total_corpses_count);
	assert(counter > 0);
	return KERN_SUCCESS;
}


kcdata_descriptor_t task_crashinfo_alloc_init(mach_vm_address_t crash_data_p, unsigned size)
{
	if(KERN_SUCCESS != task_crashinfo_get_ref()) {
		return NULL;
	}

	return kcdata_memory_alloc_init(crash_data_p, TASK_CRASHINFO_BEGIN, size, KCFLAG_USE_COPYOUT);
}


/*
 * Free up the memory associated with task_crashinfo_data
 */
kern_return_t task_crashinfo_destroy(kcdata_descriptor_t data)
{
	if (!data) {
		return KERN_INVALID_ARGUMENT;
	}

	task_crashinfo_release_ref();
	return kcdata_memory_destroy(data);
}

/*
 * Routine: task_get_corpseinfo
 * params: task - task which has corpse info setup.
 * returns: crash info data attached to task.
 *          NULL if task is null or has no corpse info
 */
kcdata_descriptor_t task_get_corpseinfo(task_t task)
{
	kcdata_descriptor_t retval = NULL;
	if (task != NULL){
		retval = task->corpse_info;
	}
	return retval;
}


