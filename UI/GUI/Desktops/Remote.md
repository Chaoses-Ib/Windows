# Remote Desktops
## Remote Desktop Protocol (RDP)
[Wikipedia](https://en.wikipedia.org/wiki/Remote_Desktop_Protocol)

> Starting with WindowsXP, Microsoft locked down concurrent RDP sessions for their workstation OSes. Windows servers allow two concurrent sessions, and you can purchase terminal services CALs to increase that. Microsoft introduced this limit on purpose (it's purely artificial), so its not something that is likely get better in the future. you may be able to use a different screen sharing protocol to allow an additional session (vnc is an option for instance) or perhaps look into alternate RDP servers for windows workstations.

- [→Microsoft Accounts](../../../Kernel/Users/Microsoft.md#rdp)

- Concurrent user sessions

  [MyBlog/Multi-user\_RDP\_Sessions\_in\_client\_Windows.md at master - database64128/MyBlog](https://github.com/database64128/MyBlog/blob/master/Multi-user_RDP_Sessions_in_client_Windows.md)

- Multiple sessions per user

  [windows server 2008 r2 - Allow multiple remote desktop connections from same user - Server Fault](https://serverfault.com/questions/124192/allow-multiple-remote-desktop-connections-from-same-user)

  Although possible, many programs do not support it well:
  - Chromium-based: One session per [`--user-data-dir`](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/user_data_dir.md)
    - WebView2
    - Edge
    - VS Code
    - Discord
  
    [Second RDP session can't open a Chrome window if first session runs Chrome already \[40293956\] - Chromium](https://issues.chromium.org/issues/40293956)

    [remote desktop - Chrome only works on the first session for multi-session logins - Stack Overflow](https://stackoverflow.com/questions/24718208/chrome-only-works-on-the-first-session-for-multi-session-logins)
  - Firefox: One session per profile
  - OneNote

Tools:
- Task Manager: Users
  - Processes
  - Connect
  - Disconnect
  - Sign off
  - Send message

- [stascorp/rdpwrap: RDP Wrapper Library](https://github.com/stascorp/rdpwrap)
  - Up to 15 concurrent sessions
  - Multiple sessions per user
  - But still one desktop per session
  - [anhkgg/SuperRDP: Super RDPWrap](https://github.com/anhkgg/SuperRDP) (discontinued)
  - [sebaxakerhtc/rdpwrap: RDP Wrapper Library](https://github.com/sebaxakerhtc/rdpwrap)
    ```pwsh
    scoop bucket add ACooper81_scoop-apps https://github.com/ACooper81/scoop-apps
    scoop install ACooper81_scoop-apps/RDPWrapperMod-Portable
    ```
  - Disable Defender during installation and trust `C:\Program Files\RDP Wrapper`
    - `reg add HKLM\SYSTEM\CurrentControlSet\Services\TermService\Parameters /v ServiceDll /t REG_EXPAND_SZ /d "%SystemRoot%\system32\termsrv.dll" /f`

      [Another third-party TermService library is installed - Issue #384 - stascorp/rdpwrap](https://github.com/stascorp/rdpwrap/issues/384#issuecomment-355833698)

  [windows 10 - Use RDP and local session at the same time? - Super User](https://superuser.com/questions/1719121/use-rdp-and-local-session-at-the-same-time)

- [Remote Desktop PassView - Recover the password of Remote Desktop Connection utility](https://www.nirsoft.net/utils/remote_desktop_password.html)

### Clients
[List of Remote Desktop Protocol clients - Wikipedia](https://en.wikipedia.org/wiki/List_of_Remote_Desktop_Protocol_clients)

- Remote Desktop Connection (formerly Microsoft Terminal Services Client, MSTSC)
  - [CLI](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/mstsc)
  - Graphics

    [Not clear/sharp font in Windows after connecting it thru Remote desktop for the 1st time - Super User](https://superuser.com/questions/836575/not-clear-sharp-font-in-windows-after-connecting-it-thru-remote-desktop-for-the)
  - Monitors
    - `/multimon`: Configures the Remote Desktop Services session monitor layout to be identical to the current client-side configuration.
    - `/span`: Matches the remote desktop width and height with the local virtual desktop, spanning across multiple monitors if necessary. To span across monitors, the monitors must be arranged to form a rectangle.

- Microsoft Remote Desktop
  - Touch-friendly
  - Better graphics
  - > Automatically detect and optimize your connection quality with RemoteFX for WAN transport enhancements.
  - > Enjoy a fast and fluid experience in your remote session by using RemoteFX technologies, including RemoteFX Multi-Touch, RemoteFX Media Streaming, Remote Desktop Easy Print, and more.
  - Update the remote session on resize
  - Less hang on login
  - 60 MiB
  - `%LOCALAPPDATA%\Packages\Microsoft.RemoteDesktop_8wekyb3d8bbwe`
    - `LocalState\RemoteDesktopData\RemoteResourceThumbnails\{GUID}.model` 51.2 KiB
  - UWP, macOS, Android, iOS, iPadOS, web

  [Introducing the Remote Desktop Windows Store App | Microsoft Community Hub](https://techcommunity.microsoft.com/blog/microsoft-security-blog/introducing-the-remote-desktop-windows-store-app/247486)

- [Remote Desktop client for Windows (Azure Virtual Desktop)](https://learn.microsoft.com/en-us/azure/virtual-desktop/users/connect-windows?pivots=remote-desktop-msi#download-and-install-the-remote-desktop-client-msi)
  - `C:\Program Files\Remote Desktop`
  - Can only Subscribe / Subscribe with URL

  > In contrast with Microsoft Remote Desktop and like the older Remote Desktop Connection program, MSRDC allows for the redirection of local USB and serial devices. MSRDC is also used by Windows Subsystem for Linux to display programs with a graphical user interface.

  [Azure Virtual Desktop - Wikipedia](https://en.wikipedia.org/wiki/Azure_Virtual_Desktop)

- Windows App
  - Require a work or school account

- rdesktop
- FreeRDP
- Remmina

Confusing namings.

[Difference between Microsoft's Remote Desktop and Remote Desktop Connection? : r/sysadmin](https://www.reddit.com/r/sysadmin/comments/binq8o/difference_between_microsofts_remote_desktop_and/)

[Can someone help explain the Microsoft Remote Desktop App mess? : r/sysadmin](https://www.reddit.com/r/sysadmin/comments/1flj69u/can_someone_help_explain_the_microsoft_remote/)

[Best AVD Client? MS Remote Desktop, Azure Virtual Desktop Preview or Windows App : r/AzureVirtualDesktop](https://www.reddit.com/r/AzureVirtualDesktop/comments/1diwwwk/best_avd_client_ms_remote_desktop_azure_virtual/)

## RustDesk
[GitHub](https://github.com/rustdesk/rustdesk)

## Splashtop
[远程支持、访问、协作-高性能远程桌面 | Splashtop](https://www.splashtop.com/cn/)

[Splashtop2 - 出色的跨平台远程桌面控制软件，可在手机平板上远程流畅玩PC游戏看电影！ - 异次元软件下载](https://www.iplaysoft.com/splashtop.html)

[一文带你玩转Splashtop远程桌面 - 知乎](https://zhuanlan.zhihu.com/p/107134459)

其它：  
[适用于iPad和Android平板电脑的数字白板应用程序-- Splashtop](https://www.splashtop.com/cn/whiteboard)

### 使用
#### 屏幕捕获选项
[Screen capturing options - Windows Streamer -- Splashtop Business - Support](https://support-splashtopbusiness.splashtop.com/hc/en-us/articles/360025019351)
- [镜像驱动程序限制 -- Splashtop Business - 支援](https://support-splashtopbusiness.splashtop.com/hc/zh-cn/articles/213583126)

  从镜像驱动切换到别的模式再切换回来时，需要重启

|  | CPU占用 |
| --- |  --- |
| 软件 | 15% |
| 硬件 | 12.5% |
| 镜像驱动 | 14% |

主观流畅度：镜像驱动\>软件\>硬件，不过差别不大

#### 远控时黑屏
[Why does Blank Screen not work on my remote computer? -- Splashtop Business - Support](https://support-splashtopbusiness.splashtop.com/hc/en-us/articles/360025297832)

以前使用黑屏似乎必须使用镜像驱动

#### 硬件加速
[Enable hardware acceleration on Splashtop Streamer -- Splashtop Business - Support](https://support-splashtopbusiness.splashtop.com/hc/en-us/articles/360039820771)

## iDisplay
[iDisplay: Turn your iPhone, iPad, iPad Mini or Android into external monitor for your Mac or Windows PC](http://getidisplay.com/)

[Turn your Tablet into a Monitor | Splashtop Wired XDisplay | Use Tablet as Second Screen](https://www.splashtop.com/wiredxdisplay)

能安装，但手机端一直连不上电脑，而 spacedesk 可以。

卸载

## spacedesk
[spacedesk | Multi Monitor App | Virtual Display Screen | Software Video Wall | Multi Monitor App | Virtual Display Screen | Software Video Wall](https://spacedesk.net/)

[spacedesk安卓下载，安卓版APK | 免费下载](https://apkpure.com/cn/spacedesk-multi-monitor-display-extension-screen/ph.spacedesk.beta)

再次安装，体验还不错。
