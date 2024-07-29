# [Dynamic-Link Libraries](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-libraries)
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
- [DLL hijacking](#dll-hijacking)
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

## DLL search order
[Dynamic-link library search order - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order)

`HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\SafeDllSearchMode`

If safe DLL search mode is enabled, then the search order is as follows:
1. [DLL redirection](#dll-redirection)
2. API sets.
3. SxS manifest redirection.
4. Loaded-module list.
5. Known DLLs.
6. **Windows 11, version 21H2 (10.0; Build 22000), and later**. The package dependency graph of the process. This is the application's package plus any dependencies specified as `<PackageDependency>` in the `<Dependencies>` section of the application's package manifest. Dependencies are searched in the order they appear in the manifest.
7. The folder from which the application loaded.
8. The system folder. Use the [**GetSystemDirectory**](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemdirectorya) function to retrieve the path of this folder.
9. The 16-bit system folder. There's no function that obtains the path of this folder, but it is searched.
10. The Windows folder. Use the [**GetWindowsDirectory**](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getwindowsdirectorya) function to get the path of this folder.
11. The current folder.
12. The directories that are listed in the `PATH` environment variable. This doesn't include the per-application path specified by the **App Paths** registry key. The **App Paths** key isn't used when computing the DLL search path.

### DLL hijacking
C++:
- [IbDllHijackLib: A C library for Windows DLL hijacking.](https://github.com/Chaoses-Ib/IbDllHijackLib)

Rust:
- [WarrenHood/proxygen: A DLL proxy generator written in Rust.](https://github.com/WarrenHood/proxygen)
  - `#[forward]` is not export forwarding, but just inline asm.
  - `#[proxy]`, `#[pre_hook]`, `#[post_hook]`
- [Kudaes/ADPT: DLL proxying for lazy people](https://github.com/Kudaes/ADPT)
- [Kazurin-775/dll-spoofer-rs: A spoofing / hijacking DLL creator written in Rust](https://github.com/Kazurin-775/dll-spoofer-rs)
- [b1-team/dll-hijack: Dll hijack -- just one macro](https://github.com/b1-team/dll-hijack)
- [aancw/DllProxy-rs: Rust Implementation of SharpDllProxy for DLL Proxying Technique](https://github.com/aancw/DllProxy-rs)
- [0xf00sec/DLLProxying-rs: a simple implementation of Proxy-DLL-Loads in Rust](https://github.com/0xf00sec/DLLProxying-rs)

### [DLL redirection](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-redirection)
`example.exe.local`

If the app has an application manifest:
```bat
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /v DevOverrideEnable /t REG_DWORD /d 1
```
And reboot.

[DLL/COM Redirection on Windows - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/sbscs/dll-com-redirection-on-windows)

## Tools
- [Dependencies: A rewrite of the old legacy software "depends.exe" in C# for Windows devs to troubleshoot dll load dependencies issues.](https://github.com/lucasg/Dependencies) (inactive)
- [Dependency Walker (depends.exe) Home Page](http://www.dependencywalker.com/) (discontinued)

  分析非常耗时。