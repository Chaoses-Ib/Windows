# Drivers
## Development
Frameworks:
1. Windows NT Driver Model
   
   Not support PnP and Power Options.
2. Windows Driver Model
3. Windows Driver Frameworks (Windows Driver Foundation)
   - Kernel-Mode Driver Framework (KMDF)
   - User-Mode Driver Framework (UMDF)
4. Universal Windows drivers

Rust:
- [windows-drivers-rs: Platform that enables Windows driver development in Rust.](https://github.com/microsoft/windows-drivers-rs)
  - [r/rust](https://www.reddit.com/r/rust/comments/16owkbv/microsoftwindowsdriversrs_platform_that_enables/)

Tools:
- Compuware DriverStudio (discontinued)

### [Windows Driver Kit](https://learn.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk)
[Wikipedia](https://en.wikipedia.org/wiki/Windows_Driver_Kit)

Windows Driver Kit (WDK), previously Driver Development Kit (DDK)

- Just installing `Windows Driver Kit` in Visual Studio is not enough

- > A full kit build string includes as its last two components, the build number and a QFE (Quick Fix Engineering) value. For example, 10.0.22621.2428 has a build number of 22621, and a QFE value of 2428.
  > 
  > To build a driver, the build number of your SDK installation must match the build number of your WDK installation. The QFE values does not need to match unless your driver uses functionality that is only available in the headers included with a later QFE.

- `Building 'MyDriver' with toolset 'WindowsKernelModeDriver10.0' and the 'Windows Driver' target platform.`

  If specified WDK is not supported, there will just be include header and macro (`_AMD64_`) errors instead of project config errors.

- `<WindowsTargetPlatformVersion>` cannot use `$(LatestTargetPlatformVersion)`, but specific versions like `10.0.26100.0`?

- [Previous WDK versions and other downloads - Windows drivers | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/drivers/other-wdk-downloads)
  - Windows 7~8.1: SDK/WDK 10.0.22000 + VS 2019
    
    WDK 10.0.22000 cannot be used with VS 2022 even targeting Windows 10? So we must install different WDKs for VS 2019 and VS 2022?

    [The Windows Driver Kit and Visual Studio 2022 -- OSR](https://www.osr.com/blog/2022/09/21/the-windows-driver-kit-and-visual-studio-2022/)

## [Installation](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/)
### NT
Libraries:
- [Windows driver samples/Hardware Event Sample/install.c](https://github.com/microsoft/Windows-driver-samples/blob/main/general/event/exe/install.c)

Tools:
- [OSR Driver Loader](https://www.osronline.com/article.cfm%5Earticle=157.htm)
- [驱动加载工具](https://bbs.pediy.com/thread-63374.htm)
- [LoadSys](https://bbs.pediy.com/thread-103484.htm)
- DriverMonitor (DriverStudio)
- [DriverLoaderPro](https://gitee.com/DragonQuestHero/Qt_Driver_Loader)
- [drv-loader](https://github.com/Midi12/drv-loader)

### WDM
Libraries:
- [libwdi: A Windows Driver Installation library for USB devices](https://github.com/pbatard/libwdi)

Tool:
- PnPUtil
  - [Unsigned Driver installer Utility for Windows](https://github.com/fawazahmed0/windows-unsigned-driver-installer)
- [qmk_installer: A Windows Driver Installer for QMK supported USB devices](https://github.com/fredizzimo/qmk_driver_installer)
- EzDriverInstaller (DriverStudio)

## Management
Tools:
- [Driver Store Explorer](https://github.com/lostindark/DriverStoreExplorer) (RAPR)
  - `scoop install driverstoreexplorer`
  - 2019-08-09~ v0.10.51.0
- [DriverView: Loaded Windows Drivers List](https://www.nirsoft.net/utils/driverview.html)
- [InstalledDriversList: View the installed drivers list on Windows operating system](https://www.nirsoft.net/utils/installed_drivers_list.html)

## [→Update](../../Windows/Update.md#drivers)
