# Ntdll.dll
<!--See [Subsystems](README.md#ntdlldll) for an introduction to Ntdll.dll.-->
**Ntdll.dll** is a special system support library primarily for the use of subsystem DLLs and native applications. (*Native* in this context refers to images that are not tied to any particular subsystem.) It contains two types of functions:[^winter]
- System service dispatch stubs to Windows executive system services
- Internal support functions used by subsystems, subsystem DLLs, and other native images
  - The image loader (functions that start with `Ldr`)
  - The heap manager
  - Windows subsystem process communication functions (functions that start with `Csr`)
  - General run-time library routines (functions that start with `Rtl`)
  - User-mode debugging (functions that start with `DbgUi`)
  - Event Tracing for Windows (functions starting in `Etw`)
  - The user-mode asynchronous procedure call (APC) dispatcher and exception dispatcher
  - A small subset of the C Run-Time (CRT) routines

## API
### Header files
> A lot of the ntdll prototypes and definitions are in `winternl.h` but unfortunately many parts are missing and/or there are only simplified versions of structures, etc.[^header-so]

- [phnt: Native API header files for the Process Hacker project.](https://github.com/processhacker/phnt) (38912 lines)
<details>

- [Fyyre/ntdll: ntdll.h - compatible with MSVC 6.0, Intel C++ Compiler and MinGW. Serves as a complete replacement for Windows.h](https://github.com/Fyyre/ntdll) (32679 lines)
- [ScyllaHide/3rdparty/ntdll](https://github.com/x64dbg/ScyllaHide/tree/master/3rdparty/ntdll) (10447 lines)
- [x64dbg/ntdll.h](https://github.com/x64dbg/x64dbg/blob/development/src/dbg/ntdll/ntdll.h) (9394 lines)
- [ZeusInjector/ntdll.h](https://github.com/Ice3man543/ZeusInjector/blob/master/ntdll.h) (5515 lines)
- [Gozi/ntdll.h](https://github.com/t3rabyt3-zz/Gozi/blob/master/ntdll.h) (4733 lines)
- [Carberp/ntdll.h](https://github.com/hryuk/Carberp/blob/master/source%20-%20absource/pro/all%20source/hvnc_dll/ntdll/ntdll.h) (3909 lines)
- [dynamorio/ntdll.h](https://github.com/rnk/dynamorio/blob/master/core/win32/ntdll.h) (2197 lines)
- [Cygwin/ntdll.h](https://github.com/Alexpux/Cygwin/blob/master/winsup/cygwin/ntdll.h) (1765 lines)
</details>

[^winter]: Windows Internals
[^header-so]: [c - Link to ntdll.lib and call functions inside ntdll.dll - Stack Overflow](https://stackoverflow.com/questions/35509388/link-to-ntdll-lib-and-call-functions-inside-ntdll-dll)