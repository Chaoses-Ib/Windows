# Remote Desktops
- [Sunshine: Self-hosted game stream host for Moonlight.](https://github.com/LizardByte/Sunshine)
- [1Remote: One Remote Access Manager to Rule Them All](https://github.com/1Remote/1Remote)

[You don't need Spacedesk, we already have Spacedesk at home (or how I stopped worrying and learned to use two iPads at once) - Discussion Hub / Home Cockpit Builders - Microsoft Flight Simulator Forums](https://forums.flightsimulator.com/t/you-dont-need-spacedesk-we-already-have-spacedesk-at-home-or-how-i-stopped-worrying-and-learned-to-use-two-ipads-at-once/588388)

[Spacedesk: An alternative that can be worth trying : r/cloudygamer](https://www.reddit.com/r/cloudygamer/comments/u2z5r6/spacedesk_an_alternative_that_can_be_worth_trying/)

[Alternative to Spacedesk - Discussion Hub / Home Cockpit Builders - Microsoft Flight Simulator Forums](https://forums.flightsimulator.com/t/alternative-to-spacedesk/507938)

[iDisplay, SpaceDesk? - PC Hardware and Related Software - ED Forums](https://forum.dcs.world/topic/165573-idisplay-spacedesk/)

## Remote Desktop Protocol (RDP)
[Wikipedia](https://en.wikipedia.org/wiki/Remote_Desktop_Protocol)

[Remote Desktop Services - Wikipedia](https://en.wikipedia.org/wiki/Remote_Desktop_Services)

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

- WDDM graphics display driver

  [PSA: If you're having issues connecting via RDP after updating to 20H2 (2004), disable WDDM. : r/sysadmin](https://www.reddit.com/r/sysadmin/comments/jni86j/psa_if_youre_having_issues_connecting_via_rdp/)

  [100 CPU after disconnected user - Issue #827 - stascorp/rdpwrap](https://github.com/stascorp/rdpwrap/issues/827#issuecomment-530970140)

  [Reconnecting to session not working (Win 10 Home 1903) - Issue #858 - stascorp/rdpwrap](https://github.com/stascorp/rdpwrap/issues/858#issuecomment-523192537)

  [Windows 10 v21H1 and RDP WDDM Bug - Windows - Spiceworks Community](https://community.spiceworks.com/t/windows-10-v21h1-and-rdp-wddm-bug/800474)

- Network detection

  [Windows 11 24H2 - RDP session hangs on logon : r/sysadmin](https://www.reddit.com/r/sysadmin/comments/1gbq4y7/windows_11_24h2_rdp_session_hangs_on_logon/)
  > Local Computer Policy> Computer Configuration > Administrative Templates > Windows Components > Remote Desktop Services > Remote Desktop Session Host > Connections > **Select network detection on the server** - set to **Enabled, Turn off Connect Time Detect and Continuous Network Detect**

  > Just turning off the continuous detection fixed the problem for me as well. No need to turn off the connect time detection.

  `REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v SelectNetworkDetect /t reg_dword /d 0x00000003 /f`

  [RDP connection immediately gets stuck at blurry login screen - Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/1141363/rdp-connection-immediately-gets-stuck-at-blurry-lo)

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

### RemoteApp
[Wikipedia](https://en.wikipedia.org/wiki/Remote_Desktop_Services#RemoteApp)

- Still cannot be in the same session

[Windows Compatibility](https://github.com/kimmknight/remoteapptool/wiki/Windows-Compatibility)

Servers:
- Windows Server

  [Configuring RemoteApp on Windows Server -- Master da Web](https://masterdaweb.com/en/blog/configuring-remoteapp-on-windows-server/)
- [kimmknight/remoteapptool: Create and manage RemoteApps hosted on Windows 7, 8, 10, 11, XP and Server. Generate RDP and MSI files for clients.](https://github.com/kimmknight/remoteapptool)
  - Scoop
    ```pwsh
    scoop bucket add hoilc_scoop-lemon https://github.com/hoilc/scoop-lemon
    scoop install hoilc_scoop-lemon/remoteapptool
    ```
  - [RAWeb: A simple web interface for your RemoteApps hosted on Windows 10, 11 and Server.](https://github.com/kimmknight/raweb)
    - Require IIS

Client:
- Remote Desktop Connection
  - Require to input password for every app
  - Remote tray icons can only be shown/hidden all at once?
- Remote Desktop
  - Not a native window
  - Require to input password every time
  - Start much more processes, some duplicated, bug?

[Introducing RemoteApp and Desktop Connections | Microsoft Community Hub](https://techcommunity.microsoft.com/blog/microsoft-security-blog/introducing-remoteapp-and-desktop-connections/246803)

[RemoteApp 隔离国内 Windows 毒瘤应用运行方案 - LetITFly BBS](https://bbs.letitfly.me/d/1199)

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
- Shitty animations now
- [licensing -- spacedesk by datronicsoft](https://www.spacedesk.net/licensing/)
- [download -- spacedesk by datronicsoft](https://www.spacedesk.net/download/#server-driver)
- Driver Console
- Idle: 53 MiB memory usage
- [PERFORMANCE TUNING](https://manual.spacedesk.net/PERFORMANCETUNING.html)
- [Videowall](https://manual.spacedesk.net/Videowall.html)

Data:
- v1.0.55 just installs into `C:\Windows\System32`...
- v2.1.37: `C:\Program Files\datronicsoft\spacedesk`
- Polluting `C:\Users\Public`

[spacedesk安卓下载，安卓版APK | 免费下载](https://apkpure.com/cn/spacedesk-multi-monitor-display-extension-screen/ph.spacedesk.beta)

再次安装，体验还不错。

### Client
- HID
  - Mouse
  - Touch
  - Pen
  - Keyboard
- Exit remote control: `Alt+Shift` / 3 fingers tap
- Graphics
  - Image quality (MJPEG): 70 by default
    - Even 100 is not lossless
  - Color depth: YUV 4.4.4 (default), 4.2.2, 4.2.0 (recommended)
  - FPS: 30 by default
  - One monitor per viewer
  - Keep display on is off by default
- Connection loss delay is 45 seconds by default
