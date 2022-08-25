# [Dynamic-Link Libraries](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-libraries)
## DLL injection
**DLL injection** is a technique used for running code within the address space of another process by forcing it to load a dynamic-link library.[^inject-wiki]

Approaches[^inject-wiki]:
- AppCertDLLs  
  DLLs listed under the registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDLLs` are loaded into every process that calls the Win32 API functions `CreateProcess`, `CreateProcessAsUser`, `CreateProcessWithLogonW`, `CreateProcessWithTokenW` and `WinExec`. DLL must be signed by a valid certificate. That is the right way to use legal DLL injection on current version of Windows - Windows 10.
- Windows hooks
- DLL hijacking
- [COM hijacking](../../../Applications/API/COM/README.md#hijacking)
- CreateRemoteThread()
- SetThreadContext()
- [APCs](../../Traps/Asynchronous%20Procedure%20Calls.md)
  - [AtomBombing](https://www.fortinet.com/blog/threat-research/atombombing-brand-new-code-injection-technique-for-windows)
- AppInit_DLLs  
  DLLs listed in the registry entry `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs` are loaded into every process that loads `User32.dll` during the initial call of that DLL. Beginning with Windows Vista, AppInit_DLLs are disabled by default.

  Beginning with Windows 7, the AppInit_DLL infrastructure supports code signing. Starting with Windows 8, the entire AppInit_DLL functionality is disabled when Secure Boot is enabled, regardless of code signing or registry settings.
  - [Persistence – AppInit DLLs – Penetration Testing Lab](https://pentestlab.blog/2020/01/07/persistence-appinit-dlls/)

[^inject-wiki]: [DLL injection - Wikipedia](https://en.wikipedia.org/wiki/DLL_injection)