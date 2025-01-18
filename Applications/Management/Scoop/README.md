# [Scoop](https://scoop.sh/)
[GitHub](https://github.com/ScoopInstaller/Scoop)

[xrgzs/sdoog: Scoop Dooge](https://github.com/xrgzs/sdoog)
- 使用说明、使用技巧

[Scoop Directory | scoop-directory](https://rasa.github.io/scoop-directory/)

[Buckets](https://scoop.sh/#/buckets)
- 1660 buckets, 43027 packages
- [Scoop buckets by number of apps | scoop-directory](https://rasa.github.io/scoop-directory/by-apps)
- [anderlli0053/DEV-tools: 📦 General development tools for applications and games and pretty much everything else too :) . Created and maintained by Andrew Poženel - anderlli0053 . 📦](https://github.com/anderlli0053/DEV-tools)
- [xrgzs/sdoog: Scoop Dooge](https://github.com/xrgzs/sdoog)

Discussions:
- 2024-09 [国粹国粹， user data 丢了， firefox 你真行。我乖乖滚回 chrome - V2EX](https://www.v2ex.com/t/1074017)

  > 既然用 scoop 你就应该禁止软件自身的自动更新功能，全部更新都应由 scoop 接手。我被这玩意整烦了，你要换 chrome 要是不关自动更新也会有问题，包括 vscode ，idea ，表现也是数据丢失。  
  > 不过我当时数据没有真的丢失，而是自动更新后会在默认目录（C:/Users/xxx/AppData/Local...）又创建一个新的缓存目录。

[hok: CLI reimplementation of Scoop in Rust](https://github.com/chawyehsu/hok)

## Installation
### Administrator
> Installation under the administrator console has been disabled by default for security considerations. If you know what you are doing and want to install Scoop as administrator. Please download the installer and manually execute it with the `-RunAsAdmin` parameter in an elevated console.

```pwsh
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
```
```pwsh
irm get.scoop.sh -outfile 'install.ps1'
.\install.ps1 -RunAsAdmin [-OtherParameters ...]
```

## `PATH` priority problem
[→User environment variables](../../../Kernel/Processes/Environment%20Variables.md#user-environment-variables)

[provide a way to create shims with different names than the original binary - Issue #11 - ScoopInstaller/Scoop](https://github.com/ScoopInstaller/Scoop/issues/11)

[Feature request: "namespacing" shims - Issue #1290 - ScoopInstaller/Scoop](https://github.com/ScoopInstaller/Scoop/issues/1290)

## Persistence
- [osmiumsilver/ScoopUpdateWrapper: A script in attempt to streamlining Windows firewall rule management for applications managed by Scoop.](https://github.com/osmiumsilver/ScoopUpdateWrapper)

## Networks
虽然 Scoop 本身在国内可直连，但是由于 Scoop 依赖 GitHub 来下载 Git，实际上是不可用的。

Mirrors:
- [xrgzs/scoop: Scoop 修改优化特别版](https://github.com/xrgzs/scoop)

- [Scoop: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。内置加速站有调用次数限制，请勿提取滥用。 镜像频率：12小时。](https://gitee.com/scoop-installer/scoop)
  - `已安装scoop,更换镜像` 只适用于已安装 Git 的情况。
  - 默认搜索不到 `versions` bucket 中的包，但是可以通过 `scoop bucket add versions` 添加。
  - `远程服务器返回错误: (404) 未找到。`？

- [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。从多个开源 bucket 仓库同步更新，包含应用 1.6w+。](https://github.com/lzwme/scoop-proxy-cn)
  - `scoop install spc/<app_name>`
