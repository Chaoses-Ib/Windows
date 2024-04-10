# Environment Variables
- `%ProgramFiles%`
- `%APPDATA%`

[ExpandEnvironmentStringsW](https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-expandenvironmentstringsw)

## Maximum length
- Windows XP：单条环境变量的上限其实是 32760 字符，但总环境块的上限是 32767，cmd 上限是 8192，注册表和 ShellExecute 是 2048，所以最小上界还是 2048 字符。

- Windows Vista：进程的总环境块没有固定限制了，但程序本身可能还是有限制，比如 cmd 还是限制 8192 字符。如果这些有限制的程序还修改了环境变量，就会导致环境变量被截断。

  [Start-Process fails with `EnvironmentBlockTooLong` error - Issue #14110 - PowerShell/PowerShell](https://github.com/PowerShell/PowerShell/issues/14110)

  [关于 Windows 10 环境变量的诡异情况 - V2EX](https://www.v2ex.com/t/836336)

- 当 cmd 继承的某个环境变量长于 8192 字符时，cmd 会**忽略**而不是截断它。

  这会导致用到 cmd 的工具在 `PATH` 长于 8192 字符时可能出现错误：
  - Scoop: [\[Bug\] Cannot update if `PATH` is longer than 8192 characters - Issue #5874 - ScoopInstaller/Scoop](https://github.com/ScoopInstaller/Scoop/issues/5874)
  - NVM for Windows

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