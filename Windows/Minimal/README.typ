#import "@local/ib:0.1.0": *
#title[Minimal Windows]
#let mib(mb) = [#mb MiB (#(mb/1024) GiB)]

- Memory: 0.25 GB is fairly enough for running,
  #mib(296) is enough for boot.
  - For boot, at least #mib(288) is needed, #mib(272) is not enough:

    `Status: 0xc00000177 Info: There isn't enough memory available to create a ramdisk device.`

    And even 288 MiB may hang on LogonUI, where #mib(296) works.
- Disk: Less than 7 GB.

= Components
- Windows Server Core
  - Memory
    - 2019: 600 MB (800 MB of normal version)
      
      Microsoft Defender removed: 400 MB, almost the same level as Linux.

      #image("assets/Core-400.png")
      #q-i[win10 core 删了 defender 只占 0.4G 内存，和 linux 差不多一个水平了]

      #image("assets/Core-200.png")
      #q-i[清 working set 作弊下，不到 0.2G 了😁]

      215\~266 MB steadily, without compressing.

      #image("assets/Core-175.png")
      *175 MiB* is almost the minimum.

    - 2019 $<$ 2022 $<$ 2016
      #footnote[#a[Microsoft Windows Server 2022 performance testing | GO-EUC][https://www.go-euc.com/windows-server-2022-performance-testing/#expectations-and-results]]

  - Disk:
    - 2019: 6.82 GB

- Microsoft Defender
  - Memory: 170\~200 MB
  - #a[ionuttbara/windows-defender-remover: A tool which is uses to remove Windows Defender in Windows 8.x, Windows 10 (every version) and Windows 11.][https://github.com/ionuttbara/windows-defender-remover]
    ```pwsh
    wget -UseBasicParsing https://github.com/ionuttbara/windows-defender-remover/archive/refs/tags/release13.tar.gz -OutFile DefenderRemover.tar.gz
    tar -x -f .\DefenderRemover.tar.gz
    cd windows-defender-remover-release13
    .\Script_Run.bat
    ```
    ```pwsh
    wget -UseBasicParsing https://github.com/ionuttbara/windows-defender-remover/releases/download/release13/DefenderRemover.exe -OutFile DefenderRemover.exe
    .\DefenderRemover.exe
    ```

- Telemetry
  - Service: DiagTrack/UtcSvc (Connected User Experiences and Telemetry)
    - Memory: 3 MB

  #a[Turn Off Telemetry in Windows 10][https://gist.github.com/FadeMind/9500d49948654b50aa870706a8ac9f04]
  ```pwsh
  wget -UseBasicParsing https://gist.github.com/FadeMind/9500d49948654b50aa870706a8ac9f04/raw/75011437954f9142660c8a392f6346b941aaddaa/fuck_telemetry.cmd -OutFile fuck_telemetry.cmd
  .\fuck_telemetry.cmd
  ```

- RDP
  #footnote[#a[TIL You can RDP into Windows Server Core : r/sysadmin][https://www.reddit.com/r/sysadmin/comments/7udfb1/til_you_can_rdp_into_windows_server_core/]]
  - Memory: \~1.5 MB, 40 MB when active.
  - Use VNC (or Windows Admin Center) instead.

- Task Manager: 4 MB

- conhost + cmd
  - Memory: 0.8\~6 MB + 0.5\~0.8 MB

- Service: SMB
  - Memory: 1 MB

- Windows Firewall
  - Disable:
    #footnote[#a[Manage Windows Firewall With the Command Line | Microsoft Learn][https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/configure-with-command-line?tabs=cmd#disable-windows-firewall]]
    ```cmd netsh advfirewall set allprofiles state off```
  - ```cmd control firewall.cpl``` not available.

- Memory
  - `EmptyWorkingSet()`
    ```pwsh
    wget -UseBasicParsing https://github.com/IgorMundstein/WinMemoryCleaner/releases/download/3.0.8/WinMemoryCleaner.exe -OutFile WinMemoryCleaner.exe
    .\WinMemoryCleaner.exe
    ```
  - Virtual memory
    #footnote[#a[How to change virtual memory size on Windows 10 | Windows Central][https://www.windowscentral.com/how-change-virtual-memory-size-windows-10]]
    - ```cmd wmic pagefile list /format:list```

#a[Optimizing Windows Server 2022 memory consumption on VPS with limited RAM | 3v-Hosting][https://3v-host.com/blog/optimizing-windows-server-2022-memory-consumption-on-vps/]
