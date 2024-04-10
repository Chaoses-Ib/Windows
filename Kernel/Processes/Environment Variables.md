# Environment Variables
- `%ProgramFiles%`
- `%APPDATA%`

[ExpandEnvironmentStringsW](https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-expandenvironmentstringsw)

## Maximum length
[What is the maximum length of an environment variable? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20100203-00/?p=15083)

单条环境变量的上限其实是 32760 字符，但总环境块的上限是 32767 ，cmd 上限是 8192 ，注册表和 ShellExecute 是 2048 ，所以最小上界还是 2048 字符。

[关于 Windows 10 环境变量的诡异情况 - V2EX](https://www.v2ex.com/t/836336)
