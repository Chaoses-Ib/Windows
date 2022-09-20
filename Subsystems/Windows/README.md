# Windows Subsystem
## Subsystem startup
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\SubSystems`:
- `Windows`: `%SystemRoot%\system32\csrss.exe ObjectDirectory=\Windows SharedSection=1024,20480,768 Windows=On SubSystemType=Windows ServerDll=basesrv,1 ServerDll=winsrv:UserServerDllInitialization,3 ServerDll=sxssrv,4 ProfileControl=Off MaxRequestThreads=16`
- `Kmode`: `\SystemRoot\System32\win32k.sys`

由于默认有两个 session，系统中会有两个 `Csrss.exe` 进程。

## Environment subsystem process
For each session, an instance of the environment subsystem process (`Csrss.exe`) loads four DLLs (`Basesrv.dll`, `Winsrv.dll`, `Sxssrv.dll`, and `Csrsrv.dll`) that contain support for the following[^winter]:
- Various housekeeping tasks related to creating and deleting processes and threads
- Shutting down Windows applications (through the `ExitWindowsEx` API)
- Containing .ini file to registry location mappings for backward compatibility
- Sending certain kernel notification messages (such as those from the Plug-and-Play 
manager) to Windows applications as Window messages (`WM_DEVICECHANGE`)
- Portions of the support for 16-bit virtual DOS machine (VDM) processes (32-bit Windows only)
- Side-by-Side (SxS)/Fusion and manifest cache support
- Several natural language support functions, to provide caching
- Handle the raw input thread and desktop thread (responsible for the mouse cursor, keyboard input, and handling of the desktop window) by `Winsrv.dll`
- Canonical Display Driver (`Cdd.dll`) for `Csrss.exe` instances associated with interactive user sessions
  - Communicating with the DirectX support in the kernel on each vertical refresh (VSync) to draw the visible desktop state without traditional hardware-accelerated GDI support

为什么 `Csrss.exe` 没有加载 `Cdd.dll`？  
`Cdd.dll` 是驱动，不是 DLL。

## Kernel-mode device driver
The kernel-mode device driver (`Win32k.sys`) contains the following:
- The window manager, which controls window displays; manages screen output; collects input from keyboard, mouse, and other devices; and passes user messages to applications
- The Graphics Device Interface (GDI), which is a library of functions for graphics output devices and includes functions for line, text, and figure drawing and for graphics manipulation
- Wrappers for DirectX support that is implemented in another kernel driver (`Dxgkrnl.sys`)

The basic window-management requirements for Windows 10–based devices vary considerably depending on the device in question. For this reasons, the functionality of Win32K.sys has been split among several kernel modules so that not all modules may be required on a specific system:[^winter]
- On full desktop systems `Win32k.sys` loads `Win32kBase.sys` and `Win32kFull.sys`
-  On phones (Windows Mobile 10) `Win32k.sys` loads `Win32kMin.sys` and `Win32kBase.sys`
-  On certain IoT systems, `Win32k.sys` might only need `Win32kBase.sys`

## Console host process
The console host process (`Conhost.exe`) provides support for console (character cell) applications (starting with Windows 7).[^winter]

## Desktop Window Manager
The Desktop Window Manager (`Dwm.exe`) allows for compositing visible window rendering into a single surface through the CDD and DirectX.[^winter]

## Subsystem DLLs
Subsystem DLLs (such as `Kernel32.dll`, `Advapi32.dll`, `User32.dll`, and `Gdi32.dll`) translate documented Windows API functions into the appropriate and undocumented (for user-mode) kernel-mode system service calls in `Ntoskrnl.exe` and `Win32k.sys`[^winter]

## Graphics device drivers
Graphics device drivers for hardware-dependent graphics display drivers, printer drivers, and video miniport drivers.[^winter]

[^winter]: Windows Internals