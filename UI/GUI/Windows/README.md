# [Windows](https://learn.microsoft.com/en-us/windows/win32/winmsg/windows)
## [Relationships](https://learn.microsoft.com/en-us/windows/win32/winmsg/window-features#window-relationships)
There are many ways that a window can relate to the user or another window. A window may be an owned window, foreground window, or background window. A window also has a z-order relative to other windows.

### [Foreground and background windows](Foreground.md)
Each process can have multiple threads of execution, and each thread can create windows. The thread that created the window with which the user is currently working is called the foreground thread, and the window is called the **foreground window**. All other threads are background threads, and the windows created by background threads are called **background windows**.

### Z-order
[How do I create a topmost window that is never covered by other topmost windows? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20110310-00/?p=11253)

[Painting only when your window is visible on the screen - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20030829-00/?p=42743)

[Determining whether your window is covered - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20030902-00/?p=42693)
- [GetClipBox function (wingdi.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-getclipbox)

#### Z-order bands
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


## [Show state](https://learn.microsoft.com/en-us/windows/win32/winmsg/window-features#window-show-state)
At any one given time, a window may be active or inactive; hidden or visible; and minimized, maximized, or restored. These qualities are referred to collectively as the **window show state**.

### Active window
An **active window** is the top-level window of the application with which the user is currently working. To allow the user to easily identify the active window, the system places it at the top of the z-order and changes the color of its title bar and border to the system-defined active window colors. Only a top-level window can be an active window. When the user is working with a child window, the system activates the top-level parent window associated with the child window.

> Originally, in 16-bit Windows, the function for getting the “current” window was `GetActiveWindow`. This obtained the active window across the entire system. One of the major changes in Win32 is the asynchronous input model, wherein windows from different input queues receive separate input. That way, one program that has stopped responding to input doesn’t clog up input for other unrelated windows. Win32 changed the meaning of `GetActiveWindow` to mean _the active window from the current input queue_.
> 
> If a program really needs to get a window from potentially other processes, it would have to use some other function that is specifically just for that. And indeed, that’s why the `GetForegroundWindow` function was added. The `GetForegroundWindow` function is _the special function specifically designed for obtaining windows from other processes_.
> 
> In fact, the unfashionableness of the active window has reached the point that people have given up on calling it the active window at all! Instead, they call it [the foreground window from the current process](http://blogs.msdn.com/oldnewthing/archive/2008/09/22/8960761.aspx#8961210). It’s like calling a land line a “wired cell phone”.[^active-raymond]

[^active-raymond]: [Eventually, nothing is special any more - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20081006-00/?p=20643)
