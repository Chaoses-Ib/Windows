# [Windows](Windows.md)
- [Versions](Windows/Versions.md)
- [Windows Update](Windows/Update.md)
- [Windows Insider](Windows/Insider.md)
- [Sources](Windows/Sources.md)
- [Chekced Build](Windows/Chekced.md)

## Kernel
- Traps
  - [Asynchronous Procedure Calls](Kernel/Traps/Asynchronous%20Procedure%20Calls.md)
- [Objects](Kernel/Objects/README.md)
- [Processes](Kernel/Processes/README.md)
  - [Environment Variables](<Kernel/Processes/Environment Variables.md>)
  - [Dynamic-Link Libraries](Kernel/Processes/DLLs/README.md)
    - [DLL Search Order](Kernel/Processes/DLLs/Search.md)
  - [Scheduling](Kernel/Processes/Scheduling/README.md)
  - [Console](Kernel/Processes/Console/README.md)
  - [Dumps](Kernel/Processes/Dumps.md)
- Threads
  - [Synchronization](Kernel/Threads/Sync/README.md)
- [→Memory Management](https://github.com/Chaoses-Ib/InformationSystems#memory-management)
- [→File Systems](https://github.com/Chaoses-Ib/InformationSystems#file-systems)
- [Power Management](Kernel/Power/README.md)
- Diagnostics
  - [Event Tracing for Windows](Kernel/Diagnostics/ETW/README.md)
- [Security](Kernel/Security/README.md)
  - [Virtualization-Based Security](Kernel/Security/Virtualization.md)
  - [User Interface Privilege Isolation](Kernel/Security/UIPI.md)
- Configuration
  - [Registry](Kernel/Configuration/Registry/README.md)
- [Drivers](Kernel/Drivers/README.md)
- Devices
  - [Time](Kernel/Devices/Time/README.md)
- [Services](Kernel/Services/README.md)
- [→Networks](<https://github.com/Chaoses-Ib/Networks/tree/main?tab=readme-ov-file#os:~:text=OS-,Windows,-Windows%20Sockets%20(Winsock>)

## [Subsystems](Subsystems/README.md)
- [Ntdll.dll](Subsystems/Ntdll.dll.md)
- [Wine](Subsystems/Wine/README.md)

### [Windows](Subsystems/Windows/README.md)
- [Windows 32-bit on Windows 64-bit (WoW64)](Subsystems/Windows/WoW64.md)
- [Windows.h](Subsystems/Windows/Windows.h.md)

### [Windows Subsystem for Linux 2 (WSL2)](Subsystems/WSL2/README.md)
- [→Kernel](https://github.com/Chaoses-Ib/Linux/blob/main/Distributions/WSL2/README.md)
- [→Networks](https://github.com/Chaoses-Ib/Networks/blob/main/OS/WSL/README.md)
- [Windows Subsystem for Android](Subsystems/WSL2/WSA.md)

## Media
### Graphics
- [DirectX](Media/Graphics/DirectX/README.md)

### [Text](Media/Text/README.md)

## User Interfaces
- [Accessibility](UI/Accessibility/README.md)
  - [Active Accessibility](UI/Accessibility/Active.md)
  - [UI Automation](UI/Accessibility/Automation/README.md)

### [Human Interface Devices](UI/HID/README.md)
- [Keyboard](UI/HID/Keyboard/README.md)
- [Mouse](UI/HID/Mouse/README.md)
- [Text](UI/HID/Text/README.md)
- [SendInput](UI/HID/SendInput.md)

### CLI
- [Sleeping](UI/CLI/Sleeping.md)

### GUI
- [Windows](UI/GUI/Windows/README.md)
  - [Foreground Windows](UI/GUI/Windows/Foreground.md)
- Messages
  - [Message Queues](UI/GUI/Messages/Queues.md)
- [Common Controls](UI/GUI/Controls/README.md)
  - [ImageList](UI/GUI/Controls/ImageList.md)

### [Shell](UI/Shell/README.md)
- [Context Menus](UI/Shell/Menus/README.md)
- [Icons](UI/Shell/Icons/README.md)
- [Taskbar](UI/Shell/Taskbar/README.md)
- [File Explorer](UI/Shell/Explorer/README.md)
- [Windows Search](UI/Shell/Search/README.md)
- [Deployment](UI/Shell/Deployment.md)

## Applications
- [Windhawk](Applications/Windhawk.md)

### [API](Applications/API/README.md)
- [Win32](Applications/API/Win32/README.md)
- [Component Object Model](Applications/API/COM/README.md)
- [Windows Runtime](Applications/API/WinRT/README.md)
- [Windows App SDK](Applications/API/AppSDK/README.md)
- [→.NET](https://github.com/Chaoses-Ib/.NET)

### Management
- [Package Formats](Applications/Management/Package%20Formats.md)
- [Installers](Applications/Management/Installers/README.md)
  - [Inno Setup](<Applications/Management/Installers/Inno Setup/README.md>)
- [Package Managers](Applications/Management/Package%20Managers.md)
  - [Scoop](Applications/Management/Scoop/README.md)
- [Application Data](Applications/Management/Data.md)