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

## RDP
[使用动态口令保护 Windows 远程桌面 | 中山大学网络与信息中心](https://inc.sysu.edu.cn/article/1050)

[Win10免密码连接远程桌面 - suv789 - 博客园](https://www.cnblogs.com/suv789/p/17939652)
