# Environment Variables
[Environment variables in Windows NT](https://web.archive.org/web/20111225045158/http://support.microsoft.com/kb/100843/EN-US)

[Everything you never wanted to know about Win32 environment blocks](https://nullprogram.com/blog/2023/08/23/)

Built-in:
- `%ProgramFiles%`
- `%APPDATA%`

[ExpandEnvironmentStringsW()](https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-expandenvironmentstringsw)

[Comprehensive List of Environment Variables in Windows 10/11 - Michael Smith](https://mikesmith.us/comprehensive-list-of-environment-variables-in-windows-10-11/)

## User environment variables
> User environment variables take precedence over system environment variables. The user `PATH` is appended to the system `PATH`.

[windows - User vs. System Environment Variables: Do System Variables Override User Variables? - Super User](https://superuser.com/questions/867728/user-vs-system-environment-variables-do-system-variables-override-user-variabl)

### `PATH`
`PATH` = system `PATH` + user `PATH`

> The `PATH` is constructed from the system `PATH`, which can be viewed in the System Environment Variables field in the System dialog box. The User `PATH` is appended to the system `PATH`. Then the `PATH` from the `AUTOEXEC.BAT` file is appended.
>
> Note: The environment variables `LibPath` and `Os2LibPath` are built the same way (system path + user path + `AUTOEXEC.BAT` path).

[batch file - Why and How is Autoexec.bat replaced in later iterations of Windows OS? - Super User](https://superuser.com/questions/1509265/why-and-how-is-autoexec-bat-replaced-in-later-iterations-of-windows-os)
> Windows NT was a completely different OS that doesn't depend on DOS, therefore all of its descendants (including Windows 2000, not only XP and up) also don't use DOS things such as AUTOEXEC.BAT. That said there's an AUTOEXEC.NT in %SystemRoot%\system32 for setting up the environment when a DOS application is launched.

This means adding any paths/programs to the system `PATH` may break other programs. Since Windows itself is also adding new programs to `C:\Windows`, updating Windows may break other programs in an unexpected way.

Examples:
- `C:\WINDOWS\system32`
  - `tar`
  - `\OpenSSH`: `ssh`, ...
- ...

Workarounds:
- Temporarily
  ```pwsh
  $env:PATH = "$(scoop prefix tar)\bin;" + $env:PATH
  ```
  ```pwsh
  $tarBin = "$(scoop prefix tar)\bin"
  if (-not $env:PATH.StartsWith("$tarBin;")) {
      $env:PATH = "$tarBin;" + $env:PATH
  }
  ```

  ```pwsh
  $backup = $env:PATH
  $env:PATH = "${env:USERPROFILE}\scoop\shims;C:\Windows\System32"
  ...
  $env:PATH = $backup
  ```

  [windows - Select program from PATH hidden behind program of the same name in powershell - Super User](https://superuser.com/questions/1753870/select-program-from-path-hidden-behind-program-of-the-same-name-in-powershell)

- Permanently

  Add/move paths to the beginning of the system environment variable `PATH` (not the user one).

## Maximum length
- Windows XP：单条环境变量的上限其实是 32760 字符，但总环境块的上限是 32767，cmd 上限是 8192，注册表和 ShellExecute 是 2048，所以最小上界还是 2048 字符。

- Windows Vista：进程的总环境块没有固定限制了，但程序本身可能还是有限制，比如 cmd 还是限制 8192 字符。如果这些有限制的程序还修改了环境变量，就会导致环境变量被截断。

  [Start-Process fails with `EnvironmentBlockTooLong` error - Issue #14110 - PowerShell/PowerShell](https://github.com/PowerShell/PowerShell/issues/14110)

  [关于 Windows 10 环境变量的诡异情况 - V2EX](https://www.v2ex.com/t/836336)

- Windows 10/11?: no limit on a user-defined environment variables, but environment blocks are limited to 2GiB, for both 32-bit and 64-bit processes

  [Everything you never wanted to know about Win32 environment blocks](https://nullprogram.com/blog/2023/08/23/)

  [Does Windows 11 have a 32,767 character limit for environment variables? - Super User](https://superuser.com/questions/1840269/does-windows-11-have-a-32-767-character-limit-for-environment-variables)
  - 953.7 MiB

- 当 cmd 继承的某个环境变量长于 8192 字符时，cmd 会**忽略**而不是截断它。

  这会导致用到 cmd 的工具在 `PATH` 长于 8192 字符时可能出现错误：
  - Scoop: [\[Bug\] Cannot update if `PATH` is longer than 8192 characters - Issue #5874 - ScoopInstaller/Scoop](https://github.com/ScoopInstaller/Scoop/issues/5874)
  - NVM for Windows

```pwsh
> $env:PATH = "${env:USERPROFILE}\scoop\shims;" + 'C:\Windows\System32;'*410
> $env:PATH.length
8229
```

[What is the maximum length of an environment variable? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20100203-00/?p=15083)

## Refresh
- PowerShell

  ```pwsh
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  ```

  [Refresh-EnvironmentVariables: Refreshes/reloads the environment variables in the current PowerShell session](https://github.com/asheroto/Refresh-EnvironmentVariables)

  [console - Reload the path in PowerShell - Stack Overflow](https://stackoverflow.com/questions/17794507/reload-the-path-in-powershell)

- refreshenv

  `scoop install refreshenv`

  Only work in cmd, not in PowerShell.

[Use fresh environment block on new terminals in Windows - Issue #47816 - microsoft/vscode](https://github.com/microsoft/vscode/issues/47816)

## CMD
[Windows Dynamic System Environment Variables](https://blog.thoughtlabs.com/blog/windows-dynamic-system-environment-variables)
