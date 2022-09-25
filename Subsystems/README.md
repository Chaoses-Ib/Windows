# Subsystems
- [Windows](Windows/README.md)
- Windows Subsystem for Linux (WSL)
  - WSL 2
  - WSL 1
- Subsystem for UNIX-based Applications (SUA) (last shipped with Windows 7)
- POSIX (last shipeed with Windows XP)
- OS/2 (last shipped with Windows 2000)

## [Ntdll.dll](Ntdll.dll.md)
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

## Pico model
The traditional subsystem model, while extensible and clearly powerful enough to have supported POSIX and OS/2 for a decade, has two important technical disadvantages that made it hard to reach broad usage of non-Windows binaries beyond a few specialized use cases:
- Because subsystem information is extracted from the Portable Executable (PE) header, it requires the source code of the original binary to rebuild it as a Windows PE executable file (.exe). This will also change any POSIX-style dependencies and system calls into Windows-style imports of the `Psxdll.dll` library.
-  It is limited by the functionality provided either by the Win32 subsystem (on which it sometimes piggybacks) or the NT kernel. Therefore, the subsystem wraps, instead of emulates, the behavior required by the POSIX application. This can sometimes lead to subtle compatibility flaws.

Luckily, the Drawbridge project from Microsoft Research provided the perfect vehicle for an updated take on subsystems. It resulted in the implementation of the **Pico model**. Under this model, the idea of a Pico provider is defined, which is a custom kernel-mode driver that receives access to specialized kernel interfaces through the `PsRegisterPicoProvider` API. The benefits of these specialized interfaces are two-fold:
- They allow the provider to create Pico processes and threads while customizing their execution contexts, segments, and store data in their respective `EPROCESS` and `ETHREAD` structures
- They allow the provider to receive a rich set of notifications whenever such processes or threads engage in certain system actions such as system calls, exceptions, APCs, page faults, termination, context changes, suspension/resume, etc.

With Windows 10 version 1607, one such Pico provider is present: `Lxss.sys` and its partner `Lxcore.sys`. As the name suggests, this refers to the **Windows Subsystem for Linux (WSL)** component, and these drivers make up the Pico provider interface for it.[^winter]

[^winter]: Windows Internals