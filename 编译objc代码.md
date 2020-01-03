# objc源码编译--基本遇到的所有问题

**最近想看看oc底层方面的知识，首先需要看看oc的源码大致了解对象、类、方法、属性创建的过程和原理。所以写下这篇文章记录一下编译源码时出现的问题。**

 - - 下载源码及所有依赖开源项目 （将所有源码保存在同一文件夹内方便后续操作）
	** 下载源码源码下载地址（https://opensource.apple.com/） 这个地址是苹果官方的开源网站可以下载很多开源的项目。（开源项目版本自己选择）**
		- 下载 objc 源码（由于iOS的源码开源的很少，所以下载mac OS的源码做研究）
		下载地址：【 https://opensource.apple.com/tarballs/objc4/ 】
		
		- Libc 依赖源码
		下载地址：【 https://opensource.apple.com/tarballs/Libc/ 】
		
		- dyld 源码
		下载地址：【 https://opensource.apple.com/tarballs/dyld/ 】
		
		- libauto 源码 
		下载地址：【 https://opensource.apple.com/tarballs/libauto/ 】
		
		- libclosure 源码 
		下载地址：【 https://opensource.apple.com/tarballs/libclosure/ 】
		
		- libdispatch  源码 
		下载地址：【 https://opensource.apple.com/tarballs/libdispatch/ 】
		
		- xnu  源码 
		下载地址：【 https://opensource.apple.com/tarballs/xnu/ 】
		
		- libpthread 源码 
		下载地址：【 https://opensource.apple.com/tarballs/libpthread/ 】
		
		- launchd   源码 
		下载地址：【 https://opensource.apple.com/tarballs/launchd/ 】
		
		- libplatform   源码 
		下载地址：【 https://opensource.apple.com/tarballs/libplatform/ 】
		

------------

- - 创建文件夹存放依赖开源包
	在objc项目中创建common文件
	![创建common文件夹](https://github.com/2826892196/learn/blob/master/pic/%E5%88%9B%E5%BB%BAcommon%E6%96%87%E4%BB%B6%E5%A4%B9.png?raw=true)

	common文件放到header search paths中
		点击项目 --> 选中TARGETS中的objc --> 点击Build Settings --> 搜索header search --> 在debug中增加$(SRCROOT)/Common
	![](https://github.com/2826892196/learn/blob/master/pic/%E6%B7%BB%E5%8A%A0common%E6%96%87%E4%BB%B6%E5%A4%B9%E5%BC%95%E7%94%A8%E7%9A%84%E5%89%AF%E6%9C%AC.png?raw=true)

- - 编译objc源码报错问题
	- 问题1  
	错误信息   
		  objc - The i386 architecture is deprecated. You should update your ARCHS build setting to remove the i386 architecture.   
		  objc-trampolines - The i386 architecture is deprecated. You should update your ARCHS build setting to remove the i386 architecture.   
	解决方案
		 target分别是objc和objc-trampolines，将i386架构移除。
		 	移除objc 点击项目 --> 选中TARGETS中的objc --> 点击Build Settings --> 搜索Architecture --> 将debug修改为Standard Architectures(64-bit intel)
		 	移除objc-trampolines 点击项目 --> 选中TARGETS中的objc-trampolines --> 点击Build Settings --> 搜索Architecture --> 将debug修改为Standard Architectures(64-bit intel)
	- 问题2
	错误信息 
		  'sys/reason.h' file not found
	解决方案
			再common中创建sys文件夹
			终端查找“reason”文件 代码：【 find . -name 'reason.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/sys/ 】例如：cp -r ./xnu-4903.221.2/bsd/sys/reason.h ./runtime/objc4-750.1/Common/sys/
	- 问题3
	错误信息 
		  'mach-o/dyld_priv.h' file not found
	解决方案
			再common中创建mach-o文件夹
			终端查找“dyld_priv”文件 代码：【 find . -name 'dyld_priv.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/mach-o/ 】例如：cp -r ./dyld-635.2/include/mach-o/dyld_priv.h ./runtime/objc4-750.1/Common/mach-o/
	- 问题4
	错误信息 
		  'os/lock_private.h' file not found
	解决方案
			再common中创建os文件夹
			终端查找“lock_private”文件 代码：【 find . -name 'lock_private.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/os/ 】例如：cp -r ./libplatform-177.200.16/private/os/lock_private.h ./runtime/objc4-750.1/Common/os/
	- 问题5
	错误信息 
		  Expected ','
	解决方案
			bridgeos猜测是mac os的touch bar支持，咱们研究源码所以不需要这个，【 删除bridgeos(3.0) 】这个代码就好
	- 问题6
	错误信息 
		  'os/base_private.h' file not found
	解决方案
			再common中创建os文件夹
			终端查找“base_private”文件 代码：【 find . -name 'base_private.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/os/ 】例如：cp -r ./libplatform-177.200.16/private/os/base_private.h ./runtime/objc4-750.1/Common/os/
	- 问题7
	错误信息 
		  'pthread/tsd_private.h' file not found
	解决方案
			再common中创建pthread文件夹
			终端查找“tsd_private”文件 代码：【 find . -name 'tsd_private.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/pthread/ 】例如：cp -r ./libpthread-330.220.2/private/tsd_private.h ./runtime/objc4-750.1/Common/pthread/
	- 问题8
	错误信息 
		  'System/machine/cpu_capabilities.h' file not found
	解决方案
			再common中创建System文件夹，在System中创建machine
			终端查找“cpu_capabilities”文件 代码：【 find . -name 'cpu_capabilities.h' 】 
			注意！！！xnu里有的版本可能没有cpu_capabilities这个文件 我下的版本是xnu-3247.1.106这里肯定有这个文件。里面有2个cpu_capabilities文件看报错信息是machine里的cpu_capabilities所以选择machine里面的。
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/System/machine/ 】例如：cp -r ./xnu-3247.1.106/osfmk/i386/cpu_capabilities.h ./runtime/objc4-750.1/Common/System/machine/
	- 问题9
	错误信息 
		  'os/tsd.h' file not found
	解决方案
			再common中创建os文件夹
			终端查找“tsd”文件 代码：【 find . -name 'tsd.h' 】
			注意！！！./xnu-3247.1.106/libsyscall/os/tsd.h、./libdispatch-1008.220.2/src/shims/tsd.h 两个地方有tsd这个文件。看报错信息是os文件夹里的tsd所以选择xnu里的tsd。
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/os/ 】例如：cp -r ./xnu-3247.1.106/osfmk/i386/cpu_capabilities.h ./runtime/objc4-750.1/Common/os/
	- 问题10
	错误信息 
		  'pthread/spinlock_private.h' file not found
	解决方案
			再common中创建pthread文件夹
			终端查找“spinlock_private”文件 代码：【 find . -name 'spinlock_private.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/pthread/ 】例如：cp -r ./libpthread-330.220.2/private/spinlock_private.h ./runtime/objc4-750.1/Common/pthread/
	- 问题11
	错误信息 
		  'CrashReporterClient.h' file not found
	解决方案
			终端查找“CrashReporterClient”文件 代码：【 find . -name 'CrashReporterClient.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/ 】例如：cp -r ./Libc-825.40.1/include/CrashReporterClient.h ./runtime/objc4-750.1/Common/
	- 问题12
	错误信息 
		  'Block_private.h' file not found
	解决方案
			终端查找“Block_private”文件 代码：【 find . -name 'Block_private.h' 】
			注意！！！./runtime/objc4-750.1/Common/Block_private.h、./libclosure-73/Block_private.h、./libdispatch-1008.220.2/src/BlocksRuntime/Block_private.h 三个地方有Block_private这个文件。选择libdispatch文件夹里的文件
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/ 】例如：cp -r ./Libc-825.40.1/include/CrashReporterClient.h ./runtime/objc4-750.1/Common/
	- 问题13
	错误信息 
		  Typedef redefinition with different types ('int' vs 'volatile OSSpinLock' (aka 'volatile int'))
	解决方案
			在OSSpinLock中有pthread_lock_t这个变量，将pthread_machdep.h文件中的变量注释掉就好了。
	- 问题14
	错误信息 
		  Typedef redefinition with different types ('int' vs 'volatile OSSpinLock' (aka 'volatile int'))
	解决方案
			在OSSpinLock中有pthread_lock_t这个变量，变量重复定义了。将pthread_machdep.h文件中的变量注释掉就好了。
	- 问题15
	错误信息 
		  Static declaration of '_pthread_has_direct_tsd' follows non-static declaration
		  Static declaration of '_pthread_getspecific_direct' follows non-static declaration
		  Static declaration of '_pthread_setspecific_direct' follows non-static declaration
	解决方案
			在tsd_private中有_pthread_has_direct_tsd这个方法，方法重复定义了。将pthread_machdep.h文件中的变量注释掉就好了。
			在tsd_private中有_pthread_getspecific_direct这个方法，方法重复定义了。将pthread_machdep.h文件中的变量注释掉就好了。
			在tsd_private中有_pthread_setspecific_direct这个方法，方法重复定义了。将pthread_machdep.h文件中的变量注释掉就好了。
	- 问题16
	错误信息 
		  'objc-shared-cache.h' file not found
	解决方案
			终端查找“objc-shared-cache”文件 代码：【 find . -name ''objc-shared-cache.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/ 】例如：cp -r ./dyld-635.2/include/objc-shared-cache.h ./runtime/objc4-750.1/Common/
	- 问题17
	错误信息 
		  Use of undeclared identifier 'DYLD_MACOSX_VERSION_10_11'
	解决方案
			在 dyld_priv.h 文件顶部加入一下宏：
			#define DYLD_MACOSX_VERSION_10_11 0x000A0B00
			#define DYLD_MACOSX_VERSION_10_12 0x000A0C00
			#define DYLD_MACOSX_VERSION_10_13 0x000A0D00
			#define DYLD_MACOSX_VERSION_10_14 0x000A0E00
	- 问题18
	错误信息 
		  'isa.h' file not found
	解决方案
			终端查找“isa”文件 代码：【 find . -name ''isa.h' 】
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/ 】例如：cp -r ./runtime/objc4-750.1/runtime/isa.h ./runtime/objc4-750.1/Common/
	- 问题19
	错误信息 
		  '_simple.h' file not found
	解决方案
			终端查找“_simple”文件 代码：【 find . -name ''_simple.h' 】
			注意！！！./Libc-825.40.1/gen/_simple.h、./libplatform-177.200.16/private/_simple.h 两个地方有_simple这个文件。选择libplatform文件夹里的文件
		 	终端拷贝代码到文件夹 代码：【 cp -r 第一步查找到的地址 源码位置/Common/ 】例如：cp -r ./runtime/objc4-750.1/runtime/isa.h ./runtime/objc4-750.1/Common/
	- 问题20
	错误信息 
		  Use of undeclared identifier 'CRGetCrashLogMessage'
	解决方案
			target -> Build Settings -> Preprocessor Macros Not Used In Precompiled  添加LIBC_NO_LIBCRASHREPORTERCLIENT
	- 问题21
	错误信息 
		  ld: can't open order file: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/AppleInternal/OrderFiles/libobjc.order
	解决方案
			target -> Build Settings -> Order File 修改为 $(SRCROOT)/libobjc.order
	- 问题22
	错误信息 
		  ld: library not found for -lCrashReporterClient
	解决方案
			target -> Build Settings -> Other Linker Flags 删掉 -lCrashReporterClient （Debug和Release都删了）
	- 问题23
	错误信息 
		SDK "macosx.internal" cannot be located.
		unable to find utility "clang++", not a developer tool or in PATH
	解决方案
			target -> build phases -> run script(markgc) -> /usr/bin/xcrun -sdk macosx clang++ -Wall -mmacosx-version-min=10.12 -arch x86_64 -std=c++11 "${SRCROOT}/markgc.cpp" -o "${BUILT_PRODUCTS_DIR}/markgc" （将macosx.internal 去掉换成macosx）
	- 问题24
	错误信息 
		error: no such public header file: '/tmp/objc.dst/usr/include/objc/ObjectiveC.apinotes'
	解决方案
			target -> Build Settings -> 搜索 Text-   将Other Text-Based InstallAPI Flags内容设置为空   Text-Based InstallAPI Verification Model值改为Errors Only
			

------------

- - 添加Debug Target
	第一步：点击加号添加target
	![](https://github.com/2826892196/learn/blob/master/pic/%E6%B7%BB%E5%8A%A0debug_1.jpg?raw=true)

	第二步：选择command line tool点击下一步
	![](https://github.com/2826892196/learn/blob/master/pic/%E6%B7%BB%E5%8A%A0debug_2.jpg?raw=true)
	
	第三步：输入项目名称 objc_test点击完成
	![](https://github.com/2826892196/learn/blob/master/pic/%E6%B7%BB%E5%8A%A0debug_3.jpg?raw=true)
	
	第四步：为objc_test添加工程依赖
	![](https://github.com/2826892196/learn/blob/master/pic/%E6%B7%BB%E5%8A%A0debug_4.jpg?raw=true)
	
	第五步：选择objc_test运行程序 发现控制台已经打印hello world了
	![](https://github.com/2826892196/learn/blob/master/pic/%E6%B7%BB%E5%8A%A0debug_4.jpg?raw=true)
	

------------

:tw-1f4a5: :tw-1f4a5::tw-1f4a5: :tw-1f4a5::tw-1f4a5: :tw-1f4a5:恭喜已经成功了可以在这研究底层代码了:tw-1f4a5: :tw-1f4a5::tw-1f4a5: :tw-1f4a5::tw-1f4a5: :tw-1f4a5:
第一次写，不太好大家凑合看。继续研究底层去了 回见了您内 :tw-1f695::tw-1f695::tw-1f695: