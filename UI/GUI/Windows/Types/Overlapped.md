# Overlapped Windows
[Window Features - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/winmsg/window-features#overlapped-windows)

## `WS_OVERLAPPEDWINDOW`
- > A child window with `WS_OVERLAPPEDWINDOW` could be turned into a frameless window, but a frameless one cannot add the frame by adding `WS_OVERLAPPEDWINDOW` style.

- Creaing an overlapped window is fast (3ms), but removing `WS_OVERLAPPEDWINDOW` is very slow (1.5s)

  [Removing `WS_OVERLAPPEDWINDOW` from Win32 child window is slow - Issue #56 - compio-rs/winio](https://github.com/compio-rs/winio/issues/56)
