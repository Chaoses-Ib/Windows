# Drivers
## Development
SDK: [Windows Driver Kit](https://learn.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk) (previously Driver Development Kit)

Frameworks:
1. Windows NT Driver Model  
   Not support PnP and Power Options.
2. Windows Driver Model
3. Windows Driver Frameworks (Windows Driver Foundation)
   - Kernel-Mode Driver Framework (KMDF)
   - User-Mode Driver Framework (UMDF)
4. Universal Windows drivers

Tools:
- Compuware DriverStudio (discontinued)

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