# Deployment
- [RegSvr32](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/regsvr32)
- [Assembly Registration Tool (RegAsm)](https://learn.microsoft.com/en-us/dotnet/framework/tools/regasm-exe-assembly-registration-tool)

  Not working?

  - [Advanced Installer](https://www.advancedinstaller.com/user-guide/registration-dialog.html)
- Server Registration Manager ([NuGet](https://www.nuget.org/packages/ServerRegistrationManager/))

  [.NET Shell Extensions - Deploying SharpShell Servers - CodeProject](https://www.codeproject.com/Articles/653780/NET-Shell-Extensions-Deploying-SharpShell-Servers)

  Compared with regasm, SRM can output installation logs, but [is considered not as stable as regasm](https://github.com/dwmkerr/sharpshell/pull/259#issuecomment-451731007).

  [Calling ServerRegistrationManager.exe to register a shell extension DLL in Windows -Advanced Installer](https://www.advancedinstaller.com/forums/viewtopic.php?t=50383)

[Installing and Uninstalling SharpShell Servers](https://github.com/dwmkerr/sharpshell/blob/main/docs/installing/installing.md)
