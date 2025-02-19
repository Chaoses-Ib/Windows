# Microsoft Defender
[Wikipedia](https://en.wikipedia.org/wiki/Microsoft_Defender_Antivirus)

Microsoft Defender Antivirus (formerly Windows Defender)

- Windows
- macOS
- Android
- iOS

Features:
- Real-time protection
  - Dev Drive protection
  - Controlled folder access
  - `MsMpEng.exe` (Antimalware Service Executable)

    High disk read and write bytes (e.g. 6.4G/1.1G), some CPU usage (0.2% on average) and high memory usage (0.3G).
- Cloud-delivered protection
- Automatic sample submission (on by default on non-Server versions)
- Tamper protection
- Ransomware data recovery
- Exclusions
- Protection updates
  - Security intelligence

## Tools
- [DefenderUI](https://www.defenderui.com/)
- [Windows Defender Log Viewer For Windows 11 and Windows 10](https://www.nirsoft.net/utils/windows_defender_log_viewer.html)
- [View Windows Defender threats on local and remote computer](https://www.nirsoft.net/utils/windows_defender_threats_view.html)

## Disabling
- Install another AV and disable its protections
  - 火绒: 0.02% CPU usage (`HipsTray.exe`), 0.1G disk read and 0.2G write, 0.26G memory usage, and 0.15G disk space

- [es3n1n/no-defender: A slightly more fun way to disable windows defender + firewall. (through the WSC api)](https://github.com/es3n1n/no-defender) ([Hacker News](https://news.ycombinator.com/item?id=40467741))
  - Require to store a minimal AV program
  - Need Git submodules to build
  - Not fully disabled. 0.05G disk read and 0.03G memory usage.
  - [Releases](https://web.archive.org/web/20240529075509/https://github.com/es3n1n/no-defender/releases)
    - https://web.archive.org/web/20240529075509mp_/https://github.com/es3n1n/no-defender/releases/download/v1.1.0/win_x64.7z
  
  https://t.me/IbDirectoryOpus/409 :
  > 通过伪造杀软来间接关闭 Windows Defender，降低硬盘读写、CPU 占用和内存占用。（Windows Defender 的每日硬盘读和写都会达到上 GB）
  > 
  > 使用 no-defender 相比只关闭实时保护的占用更低，同时相比[移除 Defender](https://github.com/ionuttbara/windows-defender-remover) 更可靠和可还原。缺点是需要每次开机自启（会自动设置），但不会驻留后台。也可用于关闭防火墙。
  > 
  > 仓库源码和程序已被微软删除，可从评论区下载。
  > 
  > 自定义杀软名称: `.\no-defender-loader.exe --name "博麗霊夢"`

  Mirrors:
  - [tajang/no-defender](https://gitee.com/tajang/no-defender) (2024-05-28)
  - [anthrax / no-defender - GitLab](https://git.lynxcore.org/anthrax/no-defender)
  - [jjsdub556/no-defender](https://github.com/jjsdub556/no-defender)

- [yowori/windows-defender-control: Manage Windows Defender in a few clicks (Windows 10/11).](https://github.com/yowori/windows-defender-control)
  - Not fully disabled. 0.2G disk read and 0.4G write, 0.05G memory usage.
  - Require to disable tamper protection

  ```pwsh
  scoop bucket add okibcn_ScoopMaster https://github.com/okibcn/ScoopMaster
  scoop install okibcn_ScoopMaster/windows-defender-control
  ```

- [TairikuOokami.Windows/Microsoft Defender Disable.bat](https://github.com/TairikuOokami/Windows/blob/main/Microsoft%20Defender%20Disable.bat)

- [AndyFul/ConfigureDefender: Utility for configuring Windows 10 built-in Defender antivirus settings.](https://github.com/AndyFul/ConfigureDefender)

- [windows-defender-remover](https://github.com/ionuttbara/windows-defender-remover)

  > This application removes / disables Windows Defender, including the Windows Security App, Windows Virtualization-Based Security (VBS), Windows SmartScreen, Windows Security Services, Windows Web-Threat Service, Windows File Virtualization (UAC), Microsoft Defender App Guard, Microsoft Driver Block List, System Mitigations and the Windows Defender page in the Settings App on Windows 10 or later.

  A bit too aggressive.

  ```pwsh
  scoop bucket add xrgzs_sdoog https://github.com/xrgzs/sdoog
  scoop install xrgzs_sdoog/windows-defender-remover
  ```
  `Script_Run.bat`

- [Defender Control: An open-source windows defender manager. Now you can disable windows defender permanently.](https://github.com/pgkt04/defender-control) (discontinued)
  
  Windows 11:
  > Works for earlier versions of Windows 11. Correct registries have not been added yet for the latest version. Update, Trusted Installer no longer has effect on the current live versions of Windows 11. Use with caution.
