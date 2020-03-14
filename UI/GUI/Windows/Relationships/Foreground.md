# Foreground Windows
Foreground windows, 前景窗口

Each process can have multiple threads of execution, and each thread can create windows. The thread that created the window with which the user is currently working is called the foreground thread, and the window is called the **foreground window**. All other threads are background threads, and the windows created by background threads are called **background windows**.

[winapi - Foreground Vs Active window - Stack Overflow](https://stackoverflow.com/questions/3940346/foreground-vs-active-window)

[SetForegroundWindow function (winuser.h) - Win32 apps | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setforegroundwindow)  
[AllowSetForegroundWindow function (winuser.h) - Win32 apps | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-allowsetforegroundwindow)

[SetForegroundWindow、SetActiveWindow、SetFocus 如何将一个某个窗口提到最顶层\_运维\_p312011150的博客 - CSDN 博客](https://blog.csdn.net/p312011150/article/details/82909861)

[LockSetForegroundWindow function (winuser.h) - Win32 apps | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-locksetforegroundwindow)  
`SPI_GETFOREGROUNDLOCKTIMEOUT`

## Implementation
```cpp
// Windows XP SP1

GetForegroundWindow() {
  NtUserGetForegroundWindow() {
    if (gpqForeground == NULL || gpqForeground->spwndActive == NULL
      || PtiCurrentShared()->rpdesk != gpqForeground->spwndActive->head.rpdesk
    )
      return 0
    else
      return gpqForeground->spwndActive
  }
}

SetForegroundWindow(hwnd) {
  NtUserSetForegroundWindow(hwnd) {
    NtUserCallHwndLock(hwnd, SFI_XXXSTUBSETFOREGROUNDWINDOW) {
      xxxStubSetForegroundWindow(pwnd) {
        xxxSetForegroundWindow(pwnd, fFlash=TRUE) {
          if ((!IsForegroundLocked() || ptiCurrent->ppi == gppiInputProvider)
            && (ptiCurrent->TIF_flags & (TIF_ALLOWFOREGROUNDACTIVATE | TIF_SYSTEMTHREAD | TIF_CSRSSTHREAD
              || CanForceForeground(ptiCurrent->ppi)
              || GiveUpForeground()
              )
            || ptiCurrent->ppi == gppiScreenSaver)
          {
            FRemoveForegroundActivate(ptiCurrent)
            xxxSetForegroundWindow2(pwnd, ptiCurrent, fFlags=0)
          }

          if (fSyncActivate)
            xxxActivateWindow(pwnd, cmd=AW_USE)
          else
            PostEventMessage(pti, pti->pq, QEVENT_ACTIVATE, pwnd=NULL, message=0, wParam=0, lParam=pwnd)
        }
      }
    }
  }
}

/*
* A process can NOT force a new foreground when:
* -There is a last input owner glinp.ptiLastWoken), and
* -The process didn't get the last hot key, key or mouse click, and
* -There is a thread with foreground priority gptiForeground), and
* -The process doesn't own the foreground thread, and
* -The process doesn't have foreground activation right, and
* -The process was not the last one to do SendInput/JournalPlayBack
* -There is a foreground queue, and
* -The last input owner is not being debugged, and
* -The foreground process is not being debugged, and
* -The last input was not long ago
*/
CanForceForeground(ppi) {
  if ((glinp.ptiLastWoken != NULL)
    && (glinp.ptiLastWoken->ppi != ppi)
    && (gptiForeground != NULL)
    && (gptiForeground->ppi != ppi)
    && !(ppi->W32PF_Flags & (W32PF_ALLOWFOREGROUNDACTIVATE | W32PF_ALLOWSETFOREGROUND))
    && (ppi != gppiInputProvider)
    && (gpqForeground != NULL)
    && (PsGetProcessDebugPort(glinp.ptiLastWoken->ppi->Process) == NULL)
    && (PsGetProcessDebugPort(gptiForeground->ppi->Process) == NULL)
    && !IsTimeFromLastRITEvent(UP(FOREGROUNDLOCKTIMEOUT))
  )
    return FALSE
  else
    return TRUE
}

xxxAllowSetForegroundWindow(dwProcessId) {
  if (CanForceForeground(PpiCurrent())) {
    if (dwProcessId != ASFW_ANY)
      glinp.ptiLastWoken = ppi->ptiList
    else
      glinp.ptiLastWoken = NULL
  }
}
```

```cpp
// Windows 11 22H2 22621.898

NtUserSetForegroundWindow(hwnd) {
  xxxSetForegroundWindowWithOptions(pwnd, 2, 0, 1) {
    // ...
    CanSetForegroundWindow {
      if (gpqForeground) {
        IsDebuggerAttached()
      }
    }
  }
}
```

## Force setting foreground window
### glinp.ptiLastWoken
- PostAccessNotification()
- xxxAllowSetForegroundWindow()
  - AllowSetForegroundWindow()

    AllowSetForegroundWindow() 会调用 CanForceForeground() 检查当前进程是否有设置前景窗口的权限，如果要利用该处的话就需要在相应前景窗口的进程上下文中进行操作，比如创建远程线程，但这很可能被杀毒软件拦截；另一种方法则是使用 SetWindowsHookEx()，部分 hook 能够在触发 hook 的线程上下文执行（不包括 WH_KEYBOARD_LL）。
- xxxDoHotKeyStuff()
  
  触发通过 RegisterHotKey() 注册的热键时会允许对应热键的线程设置前景窗口。模拟键盘输入可以激活 RegisterHotKey()，理论上来说这可以实现间接设置前景窗口为自己所能控制的窗口，但这至少需要临时占用一个组合键键位，而且在实际测试中并不可行，原因不详。

  - xxxKeyEvent()
- WakeSomeone()

  系统消息队列在分发特定消息时会唤醒对应线程，允许它设置前景窗口：
  ```cpp
  switch (message) {
    case WM_SYSKEYDOWN:
    case WM_KEYDOWN:
      if (pqmsg->msg.wParam in [VK_SHIFT, VK_CONTROL, VK_MENU] and TestKeyStateDown(pq, pqmsg->msg.wParam))
        break
      else
        fSetLastWoken = true
      break
    case WM_LBUTTONDOWN:
    case WM_LBUTTONDBLCLK:
    case WM_RBUTTONDOWN:
    case WM_RBUTTONDBLCLK:
    case WM_MBUTTONDOWN:
    case WM_MBUTTONDBLCLK:
    case WM_XBUTTONDOWN:
    case WM_XBUTTONDBLCLK:
      fSetLastWoken = true
  }
  if (fSetLastWoken)
    glinp.ptiLastWoken = ptiT
  ```

  由于前景窗口的焦点只会影响键盘输入，因此可以通过模拟鼠标输入的方式来间接设置前景窗口，但一方面模拟的鼠标输入可能产生难以预料的影响，另一方面窗口也可能被部分或完全遮挡，即使设置窗口为 topmost，也存在被同样 topmost 的前景窗口以及其它 [z-order band](README.md#z-order-bands) 的窗口遮挡的可能性。
- xxxButtonEvent()
- xxxKeyEvent()
  ```cpp
  if (Vk == VK_MENU) {
    if (fBreak) {
      if (gspwndAltTab != NULL) {
        if (gspwndActivate != NULL) {
          // Make the selected window thread the owner of the last input;
          // since the user has selected him, he owns the ALT-TAB.
          glinp.ptiLastWoken = GETPTI(gspwndActivate)
        }
      }
    } else {
      gppiLockSFW = NULL
    }
  }
  ```

  - AutoHotkey

    > Six attempts will be made to activate the target window over the course of 60ms. If all six attempts fail, WinActivate automatically sends {Alt 2} as a workaround for possible restrictions enforced by the operating system, and then makes a seventh attempt. Thus, it is usually unnecessary to follow WinActivate with `WinWaitActive`, `WinActive()` or `IfWinNotActive`.

    [AutoHotkey_L/window.cpp](https://github.com/Lexikos/AutoHotkey_L/blob/c83cfa942535301740a3d8c6bf0a7c5140300395/source/window.cpp#L88)
    
- xxxUserPowerEventCalloutWorker()
- xxxDestroyThreadInfo()

    当 GUI 线程销毁时转移前景窗口状态，如果当前进程还有其它 GUI 线程，优先转移给它们。这可能是 AllocConsole() 方法的原理。

  > If this thread got the last input event, pass ownership to another thread in this process or to the foreground thread.
- PostShellHookMessages()

   当 WM_APPCOMMAND（多媒体按键）不被前景窗口处理时，Windows 会调用 shell hook 进行处理，允许任意线程设置前景窗口。

  > If a child window does not process [WM_APPCOMMAND message](https://learn.microsoft.com/en-us/windows/win32/inputdev/wm-appcommand) and instead calls [**DefWindowProc**](https://learn.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-defwindowproca), **DefWindowProc** will send the message to its parent window. If a top level window does not process this message and instead calls **DefWindowProc**, **DefWindowProc** will call a shell hook with the hook code equal to **HSHELL_APPCOMMAND**.

  > Hack for WM_APPCOMMAND (bug 389210):
     We want to allow anyone who's listening for these wm_appcommand messages to be able to take the foreground. ie pressing mail will launch outlook AND bring it to the foreground
     We set the token to null so anyone can steal the foreground - else it isn't clear who should have the right to steal it - only one person gets the right. We let them fight it out to decide who gets foreground if more than one listener will try make a foreground change.
- xxxSendBSMtoDesktop()
- xxxSysCommand()
- xxxNextWindow()

### AllocConsole()
```cpp
AllocConsole(); 
HWND hWndConsole = GetConsoleWindow();
SetWindowPos(hWndConsole, 0, 0, 0, 0, 0, SWP_NOZORDER);  // or SWP_NOACTIVATE?
FreeConsole();
SetForegroundWindow(hWnd);
```
会导致一个窗口一闪而过；在某些情况下不起作用。

### PsGetProcessDebugPort(glinp.ptiLastWoken->ppi->Process)
被调试时总是可以 SetForegroundWindow？