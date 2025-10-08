# Windows Update
[Wikipedia](https://en.wikipedia.org/wiki/Windows_Update)

[Microsoft Update Catalog](https://www.catalog.update.microsoft.com/home.aspx)

## "Downloading - 0%" problem
- Reset Windows Update Tool
- 有可能是因为无法正常访问更新服务器，部分单位屏蔽了更新服务器。

[Windows 11 系统更新频繁下载 0%，安装 0%， 25%卡住如何解决？ - V2EX](https://fast.v2ex.com/t/975548)

## Drivers
- `HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\ExcludeWUDriversInQualityUpdate`

- Computer Configuration > Administrative Templates
  - Windows Components > Windows Update > Do not include drivers with Windows Update > Enabled (`ExcludeWUDriversInQualityUpdate`)
  - System > Device Installation
    - Prevent device metadata retrieval from the Internet > Enabled

      > The metadata setting will prevent identification and download of correct device icons. Minor thing but home users may bring it up.
    - Specify search order for device driver source locations > Enabled (Do not search Windows Update)

- Rollbacking a driver will prevent Windows from updating it again, though uninstalling it won't.

[How do I stop windows from f\*\*king up my drivers every few weeks? : r/pcmasterrace](https://www.reddit.com/r/pcmasterrace/comments/12ggm4t/how_do_i_stop_windows_from_fking_up_my_drivers/)

## Automatic updates
- Configure Automatic Updates

  > Run `gpedit.msc`, this will launch the group policy editor. Browse to Computer configuration -> Administrative Templates -> All Settings, then sort the name alphabetically, look for and double click on *Configure Automatic Updates*. In the window that opens, select *Enabled*, then in the dropdown below select option *2 - Notify for download and auto install*. This will still allow everything related to Windows Update to work normally, it will still periodically check for updates but it won't download them until you allow them. You will get a notification that you have updates available, and then you can run it when it works best for you.

  - Disabled (1)
  
    > If the status for this policy is set to Disabled, any updates that are available on Windows Update must be downloaded and installed manually. To do this, search for Windows Update using Start.
  
    Also disables get updates for other Microsoft products.

- Pause updates
  - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\FlightSettingsMaxPauseDays`

    > Change it to a DECIMAL (IMPORTANT) value that is a multiple of 7 for the amount of days you want to pause updates for. Do it for 10 years.
    - 3650 (0xe42).
    - May be reset to 7?

  [Pause your updates until 2033 on Windows | GRC Public Forums](https://forums.grc.com/threads/pause-your-updates-until-2033-on-windows.1717/)

[Is there a way to truly pause updates? : r/WindowsHelp](https://www.reddit.com/r/WindowsHelp/comments/1bl5gor/is_there_a_way_to_truly_pause_updates/)

## Tools
- [Reset Windows Update Tool: Troubleshooting Tool with Windows Updates (Developed in Dev-C++).](https://github.com/ManuelGil/Reset-Windows-Update-Tool) (discontinued)

## Windows Server
[In-place OS upgrade (feature update)](https://learn.microsoft.com/en-us/windows-server/get-started/install-upgrade-migrate#in-place-os-upgrade-feature-update):
- Media (ISO/USB/DVD)
  - `Keep personal files and apps` is disabled (because of evaluation image?)

    [Fix Permission Error and Grayed Out Keep Files in Windows Server](https://www.dozersystems.com/fix-you-dont-have-permission-error-and-grayed-out-keep-personal-files-and-apps-option-during-windows-server-in-place-upgrade/)
    ```cmd
    dism /mount-wim /wimfile:c:\ISO\SERV2016\sources\install.wim /mountdir:c:\mount /index:2
    dism /image:c:\mount /get-currentedition
    dism /image:c:\mount /get-targeteditions
    dism /image:c:\mount /set-edition:ServerStandard
    dism /unmount-wim /mountdir:c:\mount /commit
    ```
    [Keep personal files and apps option greyed out when upgrading from - Microsoft Community](https://answers.microsoft.com/en-us/windowserver/forum/all/keep-personal-files-and-apps-option-greyed-out/15b6fd41-6cce-4769-8fc0-b42c7f4c65f3)

    [Preserving Files and Settings during Windows Server 2019 Standard to 2022 Standard Upgrade - Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/1817866/preserving-files-and-settings-during-windows-serve)

    [Upgrade windows server to 2025 : r/sysadmin](https://www.reddit.com/r/sysadmin/comments/1gyocoo/upgrade_windows_server_to_2025/)

  - Acquiring update may cause crash before restart

- Windows Update (v2025)

  [哇！微软宣布Windows Server 2025将支持旧版本直接升级(2012-2022) -- 蓝点网](https://www.landiannews.com/archives/103145.html)

  [Microsoft on Windows Server 2025 in-place upgrade (KB5044284) : r/sysadmin](https://www.reddit.com/r/sysadmin/comments/1gnketk/microsoft_on_windows_server_2025_inplace_upgrade/)
  - [这真的过于离谱！部分企业运行的Windows Server 2022被自动升级到2025 -- 蓝点网](https://www.landiannews.com/archives/106464.html)
