# [Scoop](https://scoop.sh/)
[GitHub](https://github.com/ScoopInstaller/Scoop)

[Scoop Directory | scoop-directory](https://rasa.github.io/scoop-directory/)

[Buckets](https://scoop.sh/#/buckets)
- 1660 buckets, 43027 packages
- [Scoop buckets by number of apps | scoop-directory](https://rasa.github.io/scoop-directory/by-apps)

Discussions:
- 2024-09 [国粹国粹， user data 丢了， firefox 你真行。我乖乖滚回 chrome - V2EX](https://www.v2ex.com/t/1074017)

  > 既然用 scoop 你就应该禁止软件自身的自动更新功能，全部更新都应由 scoop 接手。我被这玩意整烦了，你要换 chrome 要是不关自动更新也会有问题，包括 vscode ，idea ，表现也是数据丢失。  
  > 不过我当时数据没有真的丢失，而是自动更新后会在默认目录（C:/Users/xxx/AppData/Local...）又创建一个新的缓存目录。

[hok: CLI reimplementation of Scoop in Rust](https://github.com/chawyehsu/hok)

## `PATH` priority problem
- `C:\WINDOWS\system32`
  - `tar`
  - `\OpenSSH`: `ssh`, ...

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
  [windows - Select program from PATH hidden behind program of the same name in powershell - Super User](https://superuser.com/questions/1753870/select-program-from-path-hidden-behind-program-of-the-same-name-in-powershell)

- Permanently

  Add/move scoop paths to the beginning of the system environment variable `PATH` (not the user one).

[provide a way to create shims with different names than the original binary - Issue #11 - ScoopInstaller/Scoop](https://github.com/ScoopInstaller/Scoop/issues/11)

[Feature request: "namespacing" shims - Issue #1290 - ScoopInstaller/Scoop](https://github.com/ScoopInstaller/Scoop/issues/1290)

## Networks
虽然 Scoop 本身在国内可直连，但是由于 Scoop 依赖 GitHub 来下载 Git，实际上是不可用的。

Mirrors:
- [Scoop: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。内置加速站有调用次数限制，请勿提取滥用。 镜像频率：12小时。](https://gitee.com/scoop-installer/scoop)
  - `已安装scoop,更换镜像` 只适用于已安装 Git 的情况。
  - 默认搜索不到 `versions` bucket 中的包，但是可以通过 `scoop bucket add versions` 添加。

- [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。从多个开源 bucket 仓库同步更新，包含应用 1.6w+。](https://github.com/lzwme/scoop-proxy-cn)