# [RustDesk](https://rustdesk.com/)
[GitHub](https://github.com/rustdesk/rustdesk)

[Pricing --- RustDesk](https://rustdesk.com/pricing/)
- [Access Control -- Documentation for RustDesk](https://rustdesk.com/docs/en/self-host/rustdesk-server-pro/permissions/)

## Clients
- Windows, macOS, Linux, iOS, Android, Web

### Windows
- `scoop install rustdesk`
  - [Windows Portable Elevation -- Documentation for RustDesk](https://rustdesk.com/docs/en/client/windows/windows-portable-elevation/)

    No administrative privileges or installation needed for Windows, elevate privilege locally or from remote on demand.
- https://gh-proxy.com/github.com/rustdesk/rustdesk/releases/download/1.4.1/rustdesk-1.4.1-x86_64.exe

## Server
[rustdesk/rustdesk-server: RustDesk Server Program](https://github.com/rustdesk/rustdesk-server)
- [lejianwen/rustdesk-server: RustDesk Server For Api https://github.com/lejianwen/rustdesk-api](https://github.com/lejianwen/rustdesk-server)
  - 解决当客户端登录了`Api`账号时链接超时的问题
  - s6镜像添加了`Api`支持，`Api`开源地址 <https://github.com/lejianwen/rustdesk-api>
  - 是否必须登录才能链接， `MUST_LOGIN` 默认为 `N`，设置为 `Y` 则必须登录才能链接
  - `RUSTDESK_API_JWT_KEY`，设置后会通过`JWT`校验token的合法性

[Self-host -- Documentation for RustDesk](https://rustdesk.com/docs/en/self-host/)

[Installation](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/):
- [techahold/rustdeskinstall: Easy install Script for Rustdesk](https://github.com/techahold/rustdeskinstall)

  ```sh
  wget https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh
  chmod +x install.sh
  ./install.sh
  ```
  - `/opt/rustdesk`
- [sshpc/rustdesktool: rustdesk自建、自建向日葵&todesk](https://github.com/sshpc/rustdesktool)

[Ports](https://rustdesk.com/docs/en/self-host/#how-does-self-hosted-server-work):
- ID: 21115, 21116 (TCP/UDP)
  - Pro: 21114/443
  - WS: 21118
- Relay: 21117
  - WS: 21119

```sh
hbbs 1.1.14
Purslane Ltd. <info@rustdesk.com>
RustDesk ID/Rendezvous Server

USAGE:
    hbbs [OPTIONS]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

OPTIONS:
    -c, --config <FILE>                   Sets a custom config file
    -k, --key <KEY>                       Only allow the client with the same key
        --mask <MASK>                     Determine if the connection comes from LAN, e.g. 192.168.0.0/16
    -p, --port <NUMBER(default=21116)>    Sets the listening port
    -r, --relay-servers <HOST>            Sets the default relay servers, separated by comma
    -R, --rendezvous-servers <HOSTS>      Sets rendezvous servers, separated by comma
    -M, --rmem <NUMBER(default=0)>        Sets UDP recv buffer size, set system rmem_max first, e.g., sudo sysctl -w
                                          net.core.rmem_max=52428800. vi /etc/sysctl.conf, net.core.rmem_max=52428800,
                                          sudo sysctl –p
    -s, --serial <NUMBER(default=0)>      Sets configure update serial number
    -u, --software-url <URL>              Sets download url of RustDesk software of newest version
```
```sh
hbbr 1.1.14
Purslane Ltd. <info@rustdesk.com>
RustDesk Relay Server

USAGE:
    hbbr [OPTIONS]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

OPTIONS:
    -k, --key <KEY>                       Only allow the client with the same key
    -p, --port <NUMBER(default=21117)>    Sets the listening port
```

[Community consensus on Rustdesk with all the controversy in such a short time? : r/selfhosted](https://www.reddit.com/r/selfhosted/comments/14kjvkg/community_consensus_on_rustdesk_with_all_the/)
> They are disallowing China peer from using their server. They also add another protection by disallow users connecting to peer not in same city(This apply to all users,no only in China). You need to setup your own pair server to bypass it.s

[rustdesk 还可以自建服务器么？ - V2EX](https://www.v2ex.com/t/1042367)

[Self hosted Server - how many peers are using it? : r/rustdesk](https://www.reddit.com/r/rustdesk/comments/1bdpo14/self_hosted_server_how_many_peers_are_using_it/?show=original)

[RustDesk Server | Wener Live & Life](https://wener.me/notes/software/rustdesk/server)

[【好玩儿的Docker项目】开箱即用！TeamViewer、向日葵的替代品，20分钟自建一个开源远程桌面服务------RustDesk-我不是咕咕鸽](https://blog.laoda.de/archives/docker-compose-install-rustdesk)

[RustDesk通过API防止服务器被滥用 自动编译将服务器等信息内置客户端 -- Smianao](https://www.smianao.com/1414.html)
- [通过Github Action 编译rustdesk - 文档共建 - LINUX DO](https://linux.do/t/topic/816018)

2025-07 [RustDesk 配置的我头晕 - V2EX](https://www.v2ex.com/t/1142615)

[自建 rustdesk 的最低成本是多少 - V2EX](https://www.v2ex.com/t/1138809)

### Key management
- Create `id_ed25519` and `id_ed25519.pub` on startup if not found

[moving selfhost to different server how to do keep the encryption keys the same : r/rustdesk](https://www.reddit.com/r/rustdesk/comments/zu55rq/moving_selfhost_to_different_server_how_to_do/)

### China
- 国内网络无法发起控制，但可以接受控制？

  [RustDesk 由于诈骗猖獗，暂停国内服务 - V2EX](https://v2ex.com/t/1038439)

- Censorship
  - 部分地区的运营商会不定时阻断 RustDesk
    - 即使代理 server IP 的 21115-21117 端口也会被阻断，可能是会识别握手或端口探测特征
    - 本地转发不会被阻断，但要注意 relay server 是由 ID server 分发的

  - > error: connect failed: dial tcp 1.2.3.4:21114: connectex: No connection could be made because the target machine actively refused it.

    Unrelated?

  Discussions:
  - 2022-12 [在阿里云香港服务器用 docker 搭了个 rustdesk 服务, 今天突然就不能用了 - V2EX](https://www.v2ex.com/t/904686)
  - 2024-06 [rustdesk 自建服务器连不上 - V2EX](https://www.v2ex.com/t/1050500)
  - 2025-05 [之前华为云活动买了 56 块钱的服务器，部署了 rustdesk 真是爽爆了 - V2EX](https://www.v2ex.com/t/1132762)
  - 2025-06 [自建 Rustdesk 服务 端口被阻断 - V2EX](https://v2ex.com/t/1136754)
  - 2025-06 [【求助】自建rustdesk连接deadline has elapsed](https://www.nodeseek.com/post-372625-1)
  - 2025-07 [RustDesk 自建中转服务器卡顿，疑是 UDP 打洞遭运营商限制 - V2EX](https://www.v2ex.com/t/1143224)

## API server
- [lejianwen/rustdesk-api: Custom Rustdesk Api Server, include web admin ,web client, web client v2 preview and oidc login](https://github.com/lejianwen/rustdesk-api)
  - Go
- [kingmo888/rustdesk-api-server: 基于Django的RustDesk Api&Web Server，除了支持api所有功能，还支持web注册、管理、展示等。已支持到最新1.3.1版本。](https://github.com/kingmo888/rustdesk-api-server) (inactive)
  - Python
- [lantongxue/rustdesk-api-server-pro: 🚀This is an open source Api server based on the open source RustDesk client, the implementation of the client all Api interfaces, and provides a Web-UI for the management of data.](https://github.com/lantongxue/rustdesk-api-server-pro)
- [infiniteremote/installer: Infinite Remote Installer, installs RustDesk Server and Opensource API Server, (Get an addressbook etc for free) a True Free and OSS alternative to TeamViewer, AnyDesk etc](https://github.com/infiniteremote/installer)
  - Sh, Python

## [Client configuration](https://rustdesk.com/docs/en/self-host/client-configuration/)
- Custom client generator (Pro only, basic plan or custom plan)
- Manual Config
- Setup Using Import or Export
- Automatic Config (scripts)
- Import config from `Pro` via clipboard
- [把配置放在可执行文件名里 (Windows only)](https://web.archive.org/web/20240412164951/https://rustdesk.com/docs/zh-cn/self-host/rustdesk-server-oss/install/)
  - `rustdesk-host=<host-ip-or-name>,key=<public-key-string>.exe`
  
    > If there are invalid characters in the key which can not be used in file name, please remove id_ed25519 file and restart your hbbs/hbbr, the id_ed25519.pub file will be regenerated, please repeat until you get valid characters.

    [Client configuration for self hosted server - rustdesk/rustdesk - Discussion #966](https://github.com/rustdesk/rustdesk/discussions/966)

  - `rustdesk--0nI900VsFHZVBVdIlncwpHS4V0bOZ0dtVldrpVO4JHdCp0YV5WdzUGZzdnYRVjI6ISeltmIsISMuEjLx4SMiojI0N3boJye.exe` (or `-licensed-`)

  [rustdesk/src/custom\_server.rs at 6e62c10fa06b21a5eb7dd461a2907eb1b4bc6cfc - rustdesk/rustdesk](https://github.com/rustdesk/rustdesk/blob/6e62c10fa06b21a5eb7dd461a2907eb1b4bc6cfc/src/custom_server.rs#L51)

  [Windows: Key import failure from .exe Filename creates wrong key on multiple download - Issue #11108 - rustdesk/rustdesk](https://github.com/rustdesk/rustdesk/issues/11108)
- Use command line `--config`

[rustdesk 的自建服务器问题请教 - V2EX](https://v2ex.com/t/1029489)

- ID server config always have effect, but relay server may not

  relay server 是由 ID server 分发的

  [Rustdesk suddenly seems to ignore -r flag for some connections : r/rustdesk](https://www.reddit.com/r/rustdesk/comments/1gvsi1x/rustdesk_suddenly_seems_to_ignore_r_flag_for_some/)
