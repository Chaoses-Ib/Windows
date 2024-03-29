# Windows 32-bit on Windows 64-bit
## WoW64 core
WoW64 core is implemented as a set of user-mode DLLs, with some support from the kernel for creating the target's architecture versions of what would normally only be 64-bit native data structures, such as the process environment block (PEB) and thread environment block (TEB). Changing WoW64 contexts through `Get/SetThreadContext` is also implemented by the kernel. Here are the core usermode DLLs responsible for WoW64:
- Wow64.dll
  
  Implements the WoW64 core in user mode. Creates the thin software layer that acts as a kind of intermediary kernel for 32-bit applications and starts the simulation. Handles CPU context state changes and base system calls exported by Ntoskrnl.exe. It also implements file-system redirection and registry redirection.
- Wow64win.dll
  
  Implements thunking for GUI system calls exported by Win32k.sys.
  
Both Wow64win.dll and Wow64.dll include thunking code, which converts a calling convention from an architecture to another one.

When a WoW64 process is initially created, the kernel maps both the native Ntdll and the correct WoW64 version (`C:\Windows\SysWOW64\ntdll.dll` for x86-32 processes on x86-64). The kernel also allocates the 32-bit version of the PEB and stores a pointer to it in `EWoW64PROCESS` linked to the main `EPROCESS`.[^winter]

## CPU simulators
CPU simulators are architecture-specific and are used for translating machine code that belongs to a different architecture:[^winter]
- Wow64cpu.dll
  
  Implements the CPU simulator for running x86-32 code in x86-64 operating systems. Manages the 32-bit CPU context of each running thread inside WoW64 and provides processor architecture-specific support for switching CPU mode from 32-bit to 64-bit and vice versa.
- Wowarmhw.dll
  
  Implements the CPU simulator for running ARM32 (AArch32) applications on ARM64 systems.
- Xtajit.dll
  
  Implements the CPU emulator for running x86-32 applications on ARM64 systems. Includes a full x86 emulator, a jitter (code compiler), and the communication protocol between the jitter and the XTA cache server. The jitter can create compilation blocks including ARM64 code translated from the x86 image. Those blocks are stored in a local cache.

## Libraries
- [rewolf-wow64ext: Helper library for x86 programs that runs under WOW64 layer on Windows x64](https://github.com/rwfpl/rewolf-wow64ext)
- [wow64pp: A modern C++ implementation of Windows heaven's gate](https://github.com/JustasMasiulis/wow64pp)
- [RtlWow64: C++ implementation of Windows heaven's gate](https://github.com/bb107/RtlWow64)

## Loading 64-bit DLLs
Version | Build number | kernel32.dll | advapi32.dll | user32.dll | gdi32.dll | shlwapi.dll
--- | --- | --- | --- | --- | --- | ---
Windows 11 22H2 | 22621 | ✅ | ✅ | ❌ | ❌ | ✅
Windows 10 21H2 | 19044 | ✅ | ✅ | ✅ | ✅ | ✅
Windows 10 21H1 | 19043 | ✅ | ✅ | ✅ | ✅ | ✅
Windows 10 20H2 | 19042 | ✔️NtFreeVirtualMemory | ✔️ | ✔️ | ✔️ | ✔️
Windows 7 | 7601 | ✔️NtFreeVirtualMemory | ✔️ | ✔️ | ✔️ | ✔️

NtFreeVirtualMemory: [Knockin’ on Heaven’s Gate – Dynamic Processor Mode Switching | RCE.co](http://rce.co/knockin-on-heavens-gate-dynamic-processor-mode-switching/#Issue_3_Loading_Kernel32dll_8211_Understanding_The_Constraints_and_Protections)

[^winter]: Windows Internals