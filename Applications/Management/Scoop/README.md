# Scoop
## Networks
虽然 Scoop 本身在国内可直连，但是由于 Scoop 依赖 GitHub 来下载 Git，实际上是不可用的。

Mirrors:
- [Scoop: scoop国内镜像优化库，能够加速scoop安装及bucket源文件，无需用户设置代理。内置加速站有调用次数限制，请勿提取滥用。 镜像频率：12小时。](https://gitee.com/scoop-installer/scoop)
  - `已安装scoop,更换镜像` 只适用于已安装 Git 的情况。
  - 默认搜索不到 `versions` bucket 中的包，但是可以通过 `scoop bucket add versions` 添加。

- [lzwme/scoop-proxy-cn: 适合中国大陆的 Scoop buckets 代理镜像库。从多个开源 bucket 仓库同步更新，包含应用 1.6w+。](https://github.com/lzwme/scoop-proxy-cn)