# Package Managers
- [Windows Package Manager (winget)](https://docs.microsoft.com/en-us/windows/package-manager/) ([repo](https://github.com/microsoft/winget-cli))
- [Scoop](https://scoop.sh/) ([repo](https://github.com/ScoopInstaller/Scoop))
- [Chocolatey](https://chocolatey.org/) ([repo](https://github.com/chocolatey/choco))

Comparison:
> winget：依赖注册的安装信息工作，因此自身卸载重新安装不影响安装的包（除了portable的包），别的途径安装的也能识别，也因为依赖注册的安装信息，如果程序的注册不是很规范就容易出问题，所以支持的安装包有限制。有导出导入功能。
> 
> Scoop：比较便携，整个文件夹无论放哪里都能工作，方便迁移。
> 
> Chocolatey：上面两个的缺点都有。因为有非便携版软件包，所以不方便迁移。因为完全靠本地包信息工作，所以一旦卸载重装，之前安装的包都识别不出了。[^icebox]

[^icebox]: [Windows下的包管理器推荐？ - 问题求助 - 小众软件官方论坛](https://meta.appinn.net/t/topic/35728/6)