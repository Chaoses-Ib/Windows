# AppContainer
[AppContainer for legacy apps - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/secauthz/appcontainer-for-legacy-applications-)

[AppContainer isolation - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/secauthz/appcontainer-isolation)

[Feature-based comparison of Application Virtualization and MSIX - MSIX | Microsoft Learn](https://learn.microsoft.com/en-us/windows/msix/comparisonofappvwithmsix)

[Tyranid's Lair: LowBox Token Permissive Learning Mode](https://www.tiraniddo.dev/2021/09/lowbox-token-permissive-learning-mode.html)

## Unpackaged apps
[Fun with AppContainers -- Pavel Yosifovich](https://scorpiosoftware.net/2019/01/15/fun-with-appcontainers/)
- [zodiacon/RunAppContainer: Run executables in an AppContainer](https://github.com/zodiacon/RunAppContainer)

[Public Preview : Improve Win32 app security via app isolation - Windows Developer Blog](https://blogs.windows.com/windowsdeveloper/2023/06/14/public-preview-improve-win32-app-security-via-app-isolation/)

> Win32 应用隔离，现更以 [官方教程](https://github.com/microsoft/win32-app-isolation) 呈现
> 
> 这个仓库事实上是一系列由微软官方提供的文档，包含了将现有 Win32 app 转制成 MSIX 再将 MSIX 变成隔离好的 Win32 app 的教程、转制完毕后为应用豁免所需 Win32 资源的教程，以及部分额外的文档。
> 
> Win32 的隔离基于 App Container 特性，你可以在开发者文档的 [AppContainer Isolation](https://learn.microsoft.com/en-us/windows/win32/secauthz/appcontainer-isolation) 页查询更多相关信息。
> 
> GitHub 地址： https://github.com/microsoft/win32-app-isolation

> 其实这个还用了应用简仓（app silo），从windows容器的Server Silo下放而来的，两个不同的概念  
> AppContainer不能做会话级别的隔离，也不能做到类似通过系统文件打开对话框做文件授权这样Fancy的操作（
>
> https://techcommunity.microsoft.com/t5/ask-the-performance-team/sessions-desktops-and-windows-stations/ba-p/372473  
> 不过我刚去调查了一下，app silo可能也没有实现会话隔离
>
> https://github.com/search?q=repo:riverar/mach2%20appsilo&type=code  
> 从这个windows features枚举里大概能看出好多appsilo的功能

## Libraries
### Rust
- [trailofbits/appjaillauncher-rs: AppJailLauncher in Rust](https://github.com/trailofbits/appjaillauncher-rs) (discontinued)
  - [trailofbits/flying-sandbox-monster: Sandboxed, Rust-based, Windows Defender Client](https://github.com/trailofbits/flying-sandbox-monster) (discontinued)

    [Microsoft didn't sandbox Windows Defender, so I did -The Trail of Bits Blog](https://blog.trailofbits.com/2017/08/02/microsoft-didnt-sandbox-windows-defender-so-i-did/) ([Hacker News](https://news.ycombinator.com/item?id=41769618), [r/rust](https://www.reddit.com/r/rust/comments/6r4um6/rustbased_framework_to_contain_untrustworthy_apps/))

  本来以为很少人用，没想到还有 Rust 封装

  性能损耗？

- [firehazard: Unopinionated low level API bindings focused on soundness, safety, and stronger types over raw FFI.](https://github.com/MaulingMonkey/firehazard)
- [libiris: A (work in progress) cross-platform sandboxing library](https://github.com/mtth-bfft/libiris) (inactive)
- [octocorvus/run\_app\_container: Run windows applications in AppContainer sandbox](https://github.com/octocorvus/run_app_container) (discontinued)
- [awsomearvinder/win32-containers: hacky](https://github.com/awsomearvinder/win32-containers)

## Tools
- [microsoft/SandboxSecurityTools: Security testing tools for Windows sandboxing technologies](https://github.com/microsoft/SandboxSecurityTools)
  - Launch App Container

- [WildByDesign/win32-appcontainer-tools: AppContainer tools for launching sandboxed win32 apps, changing ACL permissions and learning from ETW traces.](https://github.com/WildByDesign/win32-appcontainer-tools)

  [WildByDesign on X: "It took me about a month, but I've got my win32-appcontainer-tools ready to share. - Launch Win32 apps in AppContainer - Set ACL permissions per-container - ETW tracing for Permissive Learning Mode"](https://x.com/WildByDesign1/status/1878871094284972285)
