# Hooks
[How to disable a global hook on the specific process - NTDEV - OSR Developer Community](https://community.osr.com/t/how-to-disable-a-global-hook-on-the-specific-process/45048)

## Window hooks
[Hooks - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/winmsg/hooks)

[SetWindowsHookExW function (winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowshookexw)

## WinEvent hooks
[WinEvents Infrastructure - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/winauto/winevents-infrastructure)

[WinEvents and Active Accessibility Overview - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/winauto/winevents-overview)

[`SetWinEventHook` function (winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwineventhook)
> **Windows Store app development** If dwFlags is `WINEVENT_INCONTEXT` AND (idProcess = 0 | idThread = 0), then window hook DLLs are not loaded in-process for the Windows Store app processes and the Windows Runtime broker process unless they are installed by UIAccess processes (accessibility tools). The notification is delivered on the installer's thread.

[`NotifyWinEvent` function (winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-notifywinevent)
```cpp
PEVENTHOOK xxxProcessNotifyWinEvent(PNOTIFY pNotify) {
  ...
}

win32u.NtUserNotifyWinEvent() {

}
```
- `user32.dll`: some will call `NotifyWinEvent`, some will call `NtUserNotifyWinEvent` directly.
- ComCtl: `MyNotifyWinEvent` (from XP SP1 to Windows 11 24H2)
  - If `s_pfnNotifyWinEvent` is 1, `NotifyWinEvent` will be skipped.

[Event Constants (Winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/winauto/event-constants)
- Some events are sent by the system
  - Even without calling `NotifyWinEvent`/`NtUserNotifyWinEvent`, the loading of the DLL may be triggered
  - e.g. `NtUserShowWindow` via `KiUserCallbackDispatcher`

[Windows Hook Events -- Pavel Yosifovich](https://scorpiosoftware.net/2023/09/24/windows-hook-events/)

> In our tests (with Windows 10 version 1903), we could not force the DLL to load at the target process, and all events were handled in out-of-context fashion. The [documentation](https://docs.microsoft.com/en-us/windows/desktop/api/Winuser/nf-winuser-setwineventhook) does mention that “in some situations, even if you request `WINEVENT_INCONTEXT` events, the events will still be delivered out-of-context“, so perhaps Microsoft moved all events to our-of-context mode in recent Windows versions.[^grootkoerkampPtrHashMinimalPerfect2025]

[\[tutorial\] WinEvent Hook - Scripts and Functions - AutoHotkey Community](https://www.autohotkey.com/board/topic/20714-tutorial-winevent-hook/)

Libraries:
- Rust
  - [OpenByteDev/wineventhook-rs: A rusty wrapper over SetWinEventHook and UnhookWinEvent.](https://github.com/OpenByteDev/wineventhook-rs)

Tools:
- [AccEvent (Accessible Event Watcher) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/winauto/accessible-event-watcher)


[^grootkoerkampPtrHashMinimalPerfect2025]: Groot Koerkamp, R. (2025). PtrHash: Minimal Perfect Hashing at RAM Throughput. In P. Mutzel & N. Prezza (Eds.), 23rd International Symposium on Experimental Algorithms (SEA 2025) (Vol. 338, p. 21:1-21:21). Schloss Dagstuhl – Leibniz-Zentrum für Informatik. https://doi.org/10.4230/LIPIcs.SEA.2025.21
