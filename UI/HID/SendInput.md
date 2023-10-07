# [SendInput](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendinput)
## Keyboard

## Mouse
- 发送在非当前位置按下按钮的输入会发生什么？

  会在当前位置产生按键事件。
- 多显示器绝对移动

  ```cpp
  MOUSEINPUT {
    .dx = x * 65536 / GetSystemMetrics(SM_CXVIRTUALSCREEN),
    .dy = y * 65536 / GetSystemMetrics(SM_CYVIRTUALSCREEN),
    .dwFlags = MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_VIRTUALDESK
  }
  ```
