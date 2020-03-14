# [Window Relationships](https://learn.microsoft.com/en-us/windows/win32/winmsg/window-features#window-relationships)
Window relationships, 窗口关系

There are many ways that a window can relate to the user or another window. A window may be an owned window, foreground window, or background window. A window also has a z-order relative to other windows.

1. Foreground and Background Windows
2. Owned Windows
3. Z-Order

[Owned Windows | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows/win32/winmsg/window-features#owned-windows)

[MFC子窗口和父窗口（SetParent,SetOwner） - BeyondTechnology - 博客园](https://www.cnblogs.com/BeyondTechnology/archive/2011/03/25/1995934.html)

[Nasty gotcha: Positioning your window beneath a topmost window makes it topmost | The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20200101-00/?p=103285)

## [Foreground and background windows](Foreground.md)
Each process can have multiple threads of execution, and each thread can create windows. The thread that created the window with which the user is currently working is called the foreground thread, and the window is called the **foreground window**. All other threads are background threads, and the windows created by background threads are called **background windows**.

## Z-order
[How do I create a topmost window that is never covered by other topmost windows? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20110310-00/?p=11253)

[Painting only when your window is visible on the screen - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20030829-00/?p=42743)

[Determining whether your window is covered - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20030902-00/?p=42693)
- [GetClipBox function (wingdi.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-getclipbox)

### Z-order bands
[Window z-order in Windows 10 – ADeltaX Blog](https://blog.adeltax.com/window-z-order-in-windows-10/)

Z-order band | Used in
--- | ---
ZBID_DESKTOP | Common windows
ZBID_IMMERSIVE_BACKGROUND | 
ZBID_IMMERSIVE_APPCHROME | 
ZBID_IMMERSIVE_MOGO | Taskbar, Start menu
ZBID_IMMERSIVE_INACTIVEMOBODY | 
ZBID_IMMERSIVE_NOTIFICATION | Action Center, notifications and some system flyouts (e.g. Network, Volume)
ZBID_IMMERSIVE_EDGY | 
ZBID_SYSTEM_TOOLS | Alt-Tab view, Task Manager (with "Always on Top" enabled)
ZBID_LOCK (Windows 10 only) | 
ZBID_ABOVELOCK_UX (Windows 10 only) | Playing Now
ZBID_IMMERSIVE_IHM | 
ZBID_GENUINE_WINDOWS | 
ZBID_UIACCESS | 
| | 
ZBID_IMMERSIVE_INACTIVEDOCK |
ZBID_IMMERSIVE_ACTIVEMOBODY |
ZBID_IMMERSIVE_ACTIVEDOCK |
ZBID_IMMERSIVE_RESTRICTED | Unused
