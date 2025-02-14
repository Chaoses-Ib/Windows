# Deployment
[→Versions](Versions.md)
- Editions

## Images
- [Download Windows / Office | MAS](https://massgrave.dev/genuine-installation-media)
- [Download Windows and Linux ISO lightning fast ⚡ - OS.click](https://os.click/en)
- [MSDN, 我告诉你 - 做一个安静的工具站](https://msdn.itellyou.cn/)
  - [NEXT, ITELLYOU](https://next.itellyou.cn/Original/)

Languages:
- ~~English has Japanese IME, but not Chinese?~~ Just keyboard layout

[推荐 | 极度省心！ 3 个 Windows 原版 ISO 镜像下载站 - V2EX](https://www.v2ex.com/t/885177)

## Installation
[UEFI/GPT-based hard drive partitions](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11):
- EFI system partition (ESP): ≥100 MiB, 100/260 MiB by default

  [Windows 11 "new" EFI System Partition requirement. Autounattend.xml warning. : r/sysadmin](https://www.reddit.com/r/sysadmin/comments/13yeh3d/windows_11_new_efi_system_partition_requirement/)

  [multi boot - Create EFI partition before installing Windows 10 - Super User](https://superuser.com/questions/1308324/create-efi-partition-before-installing-windows-10/1308330#1308330)

- Microsoft reserved partition (MSR): 16 MiB ([Wikipedia](https://en.wikipedia.org/wiki/Microsoft_Reserved_Partition))

  > Add an MSR to each GPT drive to help with partition management. The MSR is a reserved partition that does not receive a partition ID. It cannot store user data.

  [The mysterious Microsoft Reserved Partition... : r/linuxquestions](https://www.reddit.com/r/linuxquestions/comments/11e8e85/the_mysterious_microsoft_reserved_partition/)

- Windows partition: NTFS

- Recovery tools partition: ≥300 MiB

  [Is the Recovery Partition Really Necessary for the Functioning of Windows? : r/Windows10](https://www.reddit.com/r/Windows10/comments/gbqwnf/is_the_recovery_partition_really_necessary_for/)
  > Without the partition it'll just stay on the `C:\` drive under `C:\Windows\System32\Recovery\winre.wim`.

  [No Recovery Partition - Windows 10 Forums](https://www.tenforums.com/performance-maintenance/210348-no-recovery-partition.html)

Tools:
- [WinNTSetup: a simple but powerful universal Windows Installer](https://msfn.org/board/topic/149612-winntsetup-v541/)

[Install windows in a partition without OS, without formatting it - Super User](https://superuser.com/questions/910080/install-windows-in-a-partition-without-os-without-formatting-it)

## Users
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

## Licensing
- [Microsoft Activation Scripts (MAS)](https://massgrave.dev/)
  - `irm https://get.activated.win | iex`
  - HWID
    - All activations can be linked to a Microsoft account without any issues.
  - KMS38
  - Online KMS
