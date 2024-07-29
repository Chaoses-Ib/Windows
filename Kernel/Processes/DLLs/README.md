# [Dynamic-Link Libraries](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-libraries)
[LoadLibrary深入分析\_xdesk的专栏-CSDN博客\_loadlibrary](https://blog.csdn.net/xiangbaohui/article/details/103743201)

[DLL与UEFI的故事之一：Windows下运行Dll的三种方式 - 知乎](https://zhuanlan.zhihu.com/p/30000572)

## DLL injection
**DLL injection** is a technique used for running code within the address space of another process by forcing it to load a dynamic-link library.[^inject-wiki]

Approaches[^inject-wiki]:
- Windows hooks
- [Process injection](../README.md#process-injection) + LoadLibrary()

  Rust:
  - [OpenByteDev/dll-syringe: A windows dll injection library written in rust.](https://github.com/OpenByteDev/dll-syringe)
  - [qbx2/dll-injector: DLL injector written in Rust](https://github.com/qbx2/dll-injector)
  - [C0D3-M4513R/inject-lib](https://github.com/C0D3-M4513R/inject-lib)

- IME
- [DLL hijacking](Search.md#dll-hijacking)
- [COM hijacking](../../../Applications/API/COM/README.md#hijacking)
- SetWinEventHook()
  
  > In our tests (with Windows 10 version 1903), we could not force the DLL to load at the target process, and all events were handled in out-of-context fashion. The [documentation](https://docs.microsoft.com/en-us/windows/desktop/api/Winuser/nf-winuser-setwineventhook) does mention that “in some situations, even if you request WINEVENT_INCONTEXT events, the events will still be delivered out-of-context“, so perhaps Microsoft moved all events to our-of-context mode in recent Windows versions.[^inject-2019]
- AppCertDLLs
  
  DLLs listed under the registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDLLs` are loaded into every process that calls the Win32 API functions `CreateProcess`, `CreateProcessAsUser`, `CreateProcessWithLogonW`, `CreateProcessWithTokenW` and `WinExec`. DLL must be signed by a valid certificate. That is the right way to use legal DLL injection on current version of Windows - Windows 10.
- AppInit_DLLs
  
  DLLs listed in the registry entry `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs` are loaded into every process that loads `User32.dll` during the initial call of that DLL. Beginning with Windows Vista, AppInit_DLLs are disabled by default.

  Beginning with Windows 7, the AppInit_DLL infrastructure supports code signing. Starting with Windows 8, the entire AppInit_DLL functionality is disabled when Secure Boot is enabled, regardless of code signing or registry settings.
  - [Persistence – AppInit DLLs – Penetration Testing Lab](https://pentestlab.blog/2020/01/07/persistence-appinit-dlls/)

[Early injection helper - Issue #197 - ramensoftware/windhawk](https://github.com/ramensoftware/windhawk/issues/197)

[^inject-wiki]: [DLL injection - Wikipedia](https://en.wikipedia.org/wiki/DLL_injection)
[^inject-2019]: Klein, Amit, Itzik Kotler, and Safebreach Labs. “Windows Process Injection in 2019,” n.d., 34.
