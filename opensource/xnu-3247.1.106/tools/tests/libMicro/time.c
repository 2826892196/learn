/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms
 * of the Common Development and Distribution License
 * (the "License").  You may not use this file except
 * in compliance with the License.
 *
 * You can obtain a copy of the license at
 * src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing
 * permissions and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL
 * HEADER in each file and include the License file at
 * usr/src/OPENSOLARIS.LICENSE.  If applicable,
 * add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your
 * own identifying information: Portions Copyright [yyyy]
 * [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright 2005 Sun Microsystems, Inc.  All rights reserved.
 * Use is subject to license terms.
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "libmicro.h"

int
benchmark_init()
{
	lm_tsdsize = 0;

	(void) sprintf(lm_usage,
	    "notes: measures time()\n");

	return (0);
}

/*ARGSUSED*/
int
benchmark(void *tsd, result_t *res)
{
	int			i;

	for (i = 0; i < lm_optB; i += 10) {
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
		(void) time(NULL);
	}
	res->re_count += i;

	return (0);
}
