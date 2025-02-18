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

## [→Users](../Kernel/Users/README.md#installation)

## [→Licensing](../Kernel/Security/Licensing.md#windows)
