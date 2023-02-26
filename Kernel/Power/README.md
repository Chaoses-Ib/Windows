# Power Management
## Modern Standby (S0 Low Power Idel)
> The main problem with Legacy Standby is that the system is not working, and therefore, for example, the user receives an email, the system can’t pick that up without waking to S0, which may or may not happen, depending on configuration and device capabilities. Even if the system wakes up to get that email, it won’t go immediately to sleep again. **Modern Standby (formerly Connected Standby)** solves both issues.
> 
> Systems that support Modern Standby normally go into this state when the system is instructed to go to Standby. The system is technically still at S0, meaning the CPU is active and code can execute. However, desktop processes (non-UWP apps) are suspended, as well as UWP apps (most are not in the foreground and suspended anyway), but background tasks created by UWP apps are allowed to execute. For example, an email client would have a background task that periodically polls for new messages.
> 
> Being in Modern Standby also means that the system is able to wake to full S0 very quickly, sometimes referred to as **Instant On**. Note that not all systems support Modern Standby, as it depends on the chipset and other platform components.[^winter]

[Modern Standby | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/modern-standby)

[随时可用的 PC 体验是这样「炼」成的，Windows 新版睡眠机制详解 - 少数派](https://sspai.com/post/72757)

[用上了这项新技术，笔记本的续航越来越差了 - 差评](https://mp.weixin.qq.com/s/cwh1YLehrDsfG0ttM6KHuw)

Disable:
```cmd
reg add HKLM\System\CurrentControlSet\Control\Power /v PlatformAoAcOverride /t REG_DWORD /d 0
REM reg delete "HKLM\System\CurrentControlSet\Control\Power" /v PlatformAoAcOverride /f
```

## Standby (S3)

## Hybrid sleep (S3+S4)
> On systems with hybrid sleep enabled, a user request to put the computer to sleep will actually be a combination of both the S3 state and the S4 state. While the computer is put to sleep, an emergency hibernation file will also be written to disk. Unlike typical hibernation files, which contain almost all active memory, the emergency hibernation file includes only data that could not be paged in at a later time, making the suspend operation faster than a typical hibernation (because less data is written to disk). Drivers will then be notified that an S4 transition is occurring, allowing them to configure themselves and save state just as if an actual hibernation request had been initiated. After this point, the system is put in the normal sleep state just like during a standard sleep transition. However, if the power goes out, the system is now essentially in an S4 state—the user can power on the machine, and Windows will resume from the emergency hibernation file.[^winter]

"The hypervisor does not support this standby state."
- [\[SOLVED\] - Hybrid Sleep and Windows 10 Hypervisor? | Tom's Hardware Forum](https://forums.tomshardware.com/threads/hybrid-sleep-and-windows-10-hypervisor.3699339/)

## Hibernate (S4)
> When the system moves to S4, the power manager saves the compressed contents of memory to a hibernation file named `Hiberfil.sys`, which is large enough to hold the uncompressed contents of memory, in the root directory of the system volume (hidden file). After it finishes saving memory, the power manager shuts off the computer. When a user subsequently turns on the computer, a normal boot process occurs, except that the boot manager checks for and detects a valid memory image stored in the hibernation file. If the hibernation file contains the saved system state, the boot manager launches `%SystemRoot%\System32\Winresume.exe`, which reads the contents of the file into memory, and then resumes execution at the point in memory that is recorded in the hibernation file.[^winter]

You can disable hibernation completely and gain some disk space by running `powercfg /h off` from an elevated command prompt.[^winter]

## Fast startup (S4)


## Tools
- powercfg
  - `powercfg /a`

[^winter]: Windows Internals