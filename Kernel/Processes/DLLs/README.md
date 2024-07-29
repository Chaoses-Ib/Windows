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
- `SetWinEventHook()`
  
  > In our tests (with Windows 10 version 1903), we could not force the DLL to load at the target process, and all events were handled in out-of-context fashion. The [documentation](https://docs.microsoft.com/en-us/windows/desktop/api/Winuser/nf-winuser-setwineventhook) does mention that “in some situations, even if you request WINEVENT_INCONTEXT events, the events will still be delivered out-of-context“, so perhaps Microsoft moved all events to our-of-context mode in recent Windows versions.[^inject-2019]
- AppCertDLLs
  
  DLLs listed under the registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDLLs` are loaded into every process that calls the Win32 API functions `CreateProcess`, `CreateProcessAsUser`, `CreateProcessWithLogonW`, `CreateProcessWithTokenW` and `WinExec`. DLL must be signed by a valid certificate. That is the right way to use legal DLL injection on current version of Windows - Windows 10.

  [Early injection helper - Issue #197 - ramensoftware/windhawk](https://github.com/ramensoftware/windhawk/issues/197#issuecomment-2255728177)
  - [Usage With AppCertDLLs key - Issue #210 - microsoft/Detours](https://github.com/microsoft/Detours/issues/210)
  
  [ntvdmx64: Run Microsoft Windows NTVDM (DOS) on 64bit Editions](https://github.com/leecher1337/ntvdmx64)
  - [Added Loader support for Windows 11 (and Win 10 with Secure Boot enab... - leecher1337/ntvdmx64@9d44d45](https://github.com/leecher1337/ntvdmx64/commit/9d44d45b8bae51e558989bec066cabc6290dc4c2#diff-43a736f22d437e1bd3b8b6a4c3ab8ff037f4847161d16e5714fbd8c3032124b7)
  - [This project will be unable to support windows 11 - Issue #140 - leecher1337/ntvdmx64](https://github.com/leecher1337/ntvdmx64/issues/140)

  [AppCertDLLs does not work in GUI apps, why? - Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/494197/appcertdlls-does-not-work-in-gui-apps-why)

- AppInit_DLLs
  
  DLLs listed in the registry entry `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs` are loaded into every process that loads `User32.dll` during the initial call of that DLL. Beginning with Windows Vista, AppInit_DLLs are disabled by default.

  Beginning with Windows 7, the AppInit_DLL infrastructure supports code signing. Starting with Windows 8, the entire AppInit_DLL functionality is disabled when Secure Boot is enabled, regardless of code signing or registry settings.
  - [Persistence – AppInit DLLs – Penetration Testing Lab](https://pentestlab.blog/2020/01/07/persistence-appinit-dlls/)

  [ntvdmx64: Run Microsoft Windows NTVDM (DOS) on 64bit Editions](https://github.com/leecher1337/ntvdmx64)
  - [This project will be unable to support windows 11 - Issue #140 - leecher1337/ntvdmx64](https://github.com/leecher1337/ntvdmx64/issues/140)

- AppVerifier

  [Early injection helper - Issue #197 - ramensoftware/windhawk](https://github.com/ramensoftware/windhawk/issues/197#issuecomment-2184111425)

[Early injection helper - Issue #197 - ramensoftware/windhawk](https://github.com/ramensoftware/windhawk/issues/197)

[^inject-wiki]: [DLL injection - Wikipedia](https://en.wikipedia.org/wiki/DLL_injection)
[^inject-2019]: Klein, Amit, Itzik Kotler, and Safebreach Labs. “Windows Process Injection in 2019,” n.d., 34.
