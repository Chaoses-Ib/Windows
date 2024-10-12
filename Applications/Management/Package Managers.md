# Package Managers
- [Windows Package Manager (winget)](https://docs.microsoft.com/en-us/windows/package-manager/) ([repo](https://github.com/microsoft/winget-cli))
- [Scoop](Scoop/README.md)
- [Chocolatey](https://chocolatey.org/) ([repo](https://github.com/chocolatey/choco))

winget and Chocolately are installer managers, only Scoop is a true package manager.

[Chocolatey vs. Scoop vs Winget - which Windows package manager to use? - Daft Dev (Blog by Mitch)](https://daftdev.blog/2024/04/01/chocolatey-vs-scoop-vs-winget---which-windows-package-manager-to-use/)

[Chocolatey and Winget Comparison - ScoopInstaller/Scoop Wiki](https://github.com/ScoopInstaller/Scoop/wiki/Chocolatey-and-Winget-Comparison)
- [Scoop vs winget - ScoopInstaller/Scoop - Discussion #4777](https://github.com/ScoopInstaller/Scoop/discussions/4777)

[Windows 系统缺失的包管理器：Chocolatey、WinGet 和 Scoop - 少数派](https://sspai.com/post/65933)

Discussions:
- 2020-12 [I wonder why the author recommend winget but not scoop. Scoop obviously has more... | Hacker News](https://news.ycombinator.com/item?id=25535018)
- 2022-04 [Winget vs Chocolatey vs Scoop : r/Windows10](https://www.reddit.com/r/Windows10/comments/u80x1v/winget_vs_chocolatey_vs_scoop/)
- 2022-08 [Windows下的包管理器推荐？ - 问题求助 - 小众软件官方论坛](https://meta.appinn.net/t/topic/35728/6)
  
  > winget：依赖注册的安装信息工作，因此自身卸载重新安装不影响安装的包（除了portable的包），别的途径安装的也能识别，也因为依赖注册的安装信息，如果程序的注册不是很规范就容易出问题，所以支持的安装包有限制。有导出导入功能。
  > 
  > Scoop：比较便携，整个文件夹无论放哪里都能工作，方便迁移。
  > 
  > Chocolatey：上面两个的缺点都有。因为有非便携版软件包，所以不方便迁移。因为完全靠本地包信息工作，所以一旦卸载重装，之前安装的包都识别不出了。

- 2023-04 [Why isn't everyone using WinGet? : r/Windows10](https://www.reddit.com/r/Windows10/comments/12uysth/why_isnt_everyone_using_winget/)

  ```cmd
  winget install powertoys
  winget install Microsoft.WindowsTerminal.Preview
  winget install File-New-Project.EarTrumpet
  winget install --id Microsoft.Powershell --source winget
  winget install arduino IDE
  winget install --id Git.Git -e --source winget
  winget install streamlink  
  ```

- 2024-01 [Scoop, choco or winget : r/Windows10](https://www.reddit.com/r/Windows10/comments/19aqmmc/scoop_choco_or_winget/)

  > Winget is the best. It has a large community and respects the Windows ecosystem, e.g., the fact that we install apps in the Program Files folder.
  > 
  > Chocolatey is troublesome, but we can configure it. It installs itself in `C:\ProgramData\chocolatey`, meaning that by design, it has no regard for doing what's right.
  > 
  > Scoop is the product of an overly zealous Linux aficionado. Its sole reason for existence is to mock PowerShell. That's why it is a sad excuse for a packet manager. It has a toxic disdain for administrative privileges, `C:\Program Files`, and any security concerns.

- 2024-07 [作为程序员你是如何搭建自己的 windows 开发环境的？ - V2EX](https://www.v2ex.com/t/1054182)

GUI:
- [UniGetUI: The Graphical Interface for your package managers. Could be terribly described as a package manager manager to manage your package managers](https://github.com/marticliment/UniGetUI)
  - [WingetUI is now UniGetUI - marticliment/UniGetUI - Discussion #1900](https://github.com/marticliment/UniGetUI/discussions/1900)
  - winget, Scoop, Chocolatey, pip, NPM, .NET Tool, PowerShell Gallery, Cargo
    - Why Cargo but no Go?
  - `winget install --exact --id MartiCliment.UniGetUI --source winget`
  - `scoop install wingetui`
    ```cmd
    Checking hash of WingetUI.Installer.exe ... ok.
    Extracting WingetUI.Installer.exe ... ERROR Exit code was 1!
    Failed to extract files from C:\Users\Chaoses\scoop\apps\wingetui\3.1.1\WingetUI.Installer.exe.
    Log file:
    ~\scoop\apps\wingetui\3.1.1\innounp.log

    Please try again or create a new issue by using the following link and paste your console output:
    https://github.com/ScoopInstaller/Extras/issues/new?title=wingetui%403.1.1%3a+decompress+error
    ```

## winget
[winget-pkgs: The Microsoft community Windows Package Manager manifest repository](https://github.com/microsoft/winget-pkgs)
> At this time installers must be MSIX, MSI, APPX, or .exe application installers. Script-based installers and fonts are not currently supported.

Search:
- [Browse the winget repository - winstall](https://winstall.app/)
  - 7000+ packages
- [winget.run | Finding winget packages made simple.](https://winget.run/)

[windows - List all packages installed with winget - Stack Overflow](https://stackoverflow.com/questions/75228294/list-all-packages-installed-with-winget)

GUI:
- Windows Store
- UniGetUI
- [Winget-Install-GUI: WiGui is a tool to search, select and install Apps at once with Winget package manager](https://github.com/Romanitho/Winget-Install-GUI)
  - [Winget-AutoUpdate: WAU daily updates apps as system and notify connected users. (Allowlist and Blocklist support)](https://github.com/Romanitho/Winget-AutoUpdate)