# Users
[Local Accounts | Microsoft Learn](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/local-accounts)

- Computer Management: `compmgmt.msc`
  - `lusrmgr.msc`
- `wmic useraccount get`
  - `'wmic' is not recognized as an internal or external command, operable program or batch file.`
- `Get-LocalUser`
- `netplwiz`

[How to View All User Accounts on Windows 11](https://www.howtogeek.com/how-to-view-all-user-accounts-on-windows-11/)

## Installation
- [→Microsoft account](Microsoft.md)

- Local account
  - `1@1.com`, `no@thankyou.com`
  - Domain join
  - Install without internet

  [如何优雅的跳过 win10/win11 新系统强制登录微软账号 - V2EX](https://www.v2ex.com/t/940889)
  > 光自动创建的用户文件夹名字强制为微软账户前几位就很不好了吧😂还得自己改，改完还得惶恐有没有一些撒比软件直接把用户文件夹的绝对路径存到注册表 /配置文件里导致改了也不生效。以前我都是本地建账户再关联微软账号的，怕了。

- > You can't sign in here with a personal account. Use your work or school account instead.
  - Local account

  ["You can't sign in here with a personal account. Use your work or school account instead" on setup after upgrading to Windows 11. Any way around this? : r/WindowsHelp](https://www.reddit.com/r/WindowsHelp/comments/104rjr7/you_cant_sign_in_here_with_a_personal_account_use/)

  [Win11 LTSC 安装提示"无法使用个人帐户在此登录，请改用工作或学校帐户"](https://techzhi.com/143.htm)

## Auto logon
Auto logon is disabled by default, which means startup programs (except services) will not run until the user logs in.

[Configure Windows to automate logon - Windows Server | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/user-profiles-and-logon/turn-on-automatic-logon)

[Auto login a user at boot on Windows Server 2016? - Server Fault](https://serverfault.com/questions/840557/auto-login-a-user-at-boot-on-windows-server-2016)

[Windows11 如何实现开机唤醒跳过锁屏界面？ - V2EX](https://www.v2ex.com/t/1120281)
> 开机自动登录进入桌面  
> 运行 `netplwiz` 之后取消选定 Users must enter a user name and password to use this computer. 点 Apply 然后在弹出的对话框里输入自动登录的用户名和密码（两次）。`netplwiz` 看不到复选框的改一下注册表，  
> `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device ，DevicePasswordLessBuildVersion` 值改为 0
- Can only auto logon one user
- Windows Server 默认为 2，需要改为 0

> 睡眠唤醒直接进桌面无锁屏登录  
> 在组策略（ win+r 输入 `gpedit.msc` ）中计算机配置 > 管理模板 > 系统 > 电源管理 > 睡眠设置 >当唤醒计算机时需要密码（使用电池）（充电） 2 个都设置为禁用。  
> 家庭版没有组策略，需要直接升级专业版，网上一些家庭版开启组策略的脚本和方法都不好使，升级专业版更简单。

## RDP
[使用动态口令保护 Windows 远程桌面 | 中山大学网络与信息中心](https://inc.sysu.edu.cn/article/1050)

[Win10免密码连接远程桌面 - suv789 - 博客园](https://www.cnblogs.com/suv789/p/17939652)
