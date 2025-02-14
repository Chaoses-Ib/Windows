# Microsoft Accounts
[Wikipedia](https://en.wikipedia.org/wiki/Microsoft_account)

Microsoft account (MSA) (previously known as Microsoft Passport, .NET Passport, Windows Live ID)

- User name: `MicrosoftAccount\alice@outlook.com`
- A local account can be linked with a Microsoft account later.
  - Name (`%USERPROFILE%`) will not change.
  - Full name will be changed to the Microsoft account name.
- [→RDP](#rdp)

[Microsoft accounts | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-microsoft-accounts)
> Microsoft sites, services, properties, and computers running Windows 10 can use a Microsoft account as a way to identify a user. A Microsoft account has user-defined secrets and consists of a unique email address and a password.
>
> When a user signs in with a Microsoft account, the device is connected to cloud services. The user can share many of their settings, preferences, and apps across devices.

> Although the Microsoft account was designed to serve consumers, you might have situations in which your domain users might benefit by using their personal Microsoft account in your enterprise.
> 
> A user can connect a Microsoft account to their domain account and sync the settings and preferences between the accounts. By syncing settings and preferences between accounts, the user sees the same desktop background, app settings, browser history and favorites, and other Microsoft account settings on their other devices.

[How to Tell if Local Account or Microsoft Account in Windows 10 | Tutorials](https://www.tenforums.com/tutorials/5387-how-tell-if-local-account-microsoft-account-windows-10-a.html)

[Pros and Cons of Local user vs Microsoft user login? : r/microsoft](https://www.reddit.com/r/microsoft/comments/1cb1iti/pros_and_cons_of_local_user_vs_microsoft_user/)

[Windows 10- Microsoft account vs Local account - Microsoft Community](https://answers.microsoft.com/en-us/windows/forum/all/windows-10-microsoft-account-vs-local-account/de1330af-1771-4c5e-9bde-b19bff619e9b)

## RDP
RDP with Microsoft accounts is problematic.

[windows 远程桌面 rdp 登陆问题 - V2EX](https://v2ex.com/t/1061300)
> 当首次登录 windows 时，系统会让你登录微软账号。此时当成功登录微软账号后，系统会为这个微软账号创建一个本地账号，通常账号名是邮箱前缀。
> 
> 但如果 windows 上已有一个相同前缀的本地账号，比如先使用"abc@outlook.com"登录，生成了本地账号"abc"，又使用"abc@icloud.com"登录，那么系统则会为创建的本地账号名添加随机后缀。例如第二个本地账号为"abc_2qoabc"。
> 
> 当我们初次使用微软账号登录 windows 时，本地帐号(Local Account)的密码会同步成微软账号(Microsoft Account)的密码。
> 
> 但是当我们使用网页修改微软账号(Microsoft Account)的密码后，新的密码并不会同步到本地账号上(Local Account)。而使用 rdp 服务不需要与微软服务器进行对话, 只需要客户端与目的计算机对话, 所以仍能使用旧密码登录远程桌面。要想改变登录远程桌面的密码，就只能手动触发同步密码的流程。
> 
> 目前我找到的是在锁屏界面点击"忘掉了 pin"，重新登陆下微软账号即可，并不需要重设 PIN 。只需要登录账号，然后取消操作就行。我看到网上说"将微软账号转成本地账号"或是"退出微软账号"，之后重新登录微软账号也可以触发同步流程。但是在 windows 11 上我没有找到这些操作的按钮，也比较担心这些操作可能带来的副作用，就没有尝试了。
>
> `runas /u:MicrosoftAccount\example@outlook.com winver`
>
> 如果是 Azure Active Directory / Entra ID 的用户，前面的 MicrosoftAccount 会变成 AzureAD 。不过创建一个本地账户是好习惯，因为 WinRE 的有些恢复功能需要本地管理员账户才能使用。

[如何通过微软账号登录远程桌面 -- frendguo\\'s blog](https://frendguo.com/remote-desktop-with-sign-in-microsft-accout/)

Discussions:
- 2019-12 [WIN10 的远程桌面账号密码到底是什么？？？ - V2EX](https://v2ex.com/t/629651)
  
  > 说一下我的问题和解决方法：我先创建了本地账户，然后登录了微软账户。开启远程选项后，不能登录，按照楼主补充的步骤操作后，问题依旧。根本原因是我创建本地账户的时候，也创建了 PIN，并使用 PIN 登录。如果在登录了微软账户后没有使用过远程账户，那么你需要注销当前账户，在登录界面不要使用 PIN，而是使用微软账户密码来登录。随后，就可以使用微软账户登录远程桌面了。其实就是之前没有缓存微软账户的密码，所以登不了。
- 2023-05 [Windows11 远程桌面的这个用户名和密码到底是什么 - V2EX](https://v2ex.com/t/936942)
- 2024-11 [微软账号已经设置无密码了RDP登录时输入密码怎么填写？ - 开发调优 - LINUX DO](https://linux.do/t/topic/262594)
