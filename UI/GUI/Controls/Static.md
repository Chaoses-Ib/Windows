# [Static](https://learn.microsoft.com/en-us/windows/win32/controls/static-controls)
[About Static Controls - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/about-static-controls)

> Although static controls are child windows, they cannot be selected. Therefore, they cannot receive the keyboard focus and cannot have a keyboard interface. A static control that has the `SS_NOTIFY` style receives mouse input, notifying the parent window when the user clicks or double clicks the control.

- Without `SS_NOTIFY`, static will return `HTTRANSPARENT` for `WM_NCHITTEST`
  - Tooltip won't work

    [fix(win32): label tooltip by Chaoses-Ib - Pull Request #59 - compio-rs/winio](https://github.com/compio-rs/winio/pull/59)
