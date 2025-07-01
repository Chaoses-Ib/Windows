# Window Classes
[Create a window - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/learnwin32/creating-a-window#window-classes)

[RegisterClassExW function (winuser.h) - Win32 apps | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registerclassexw)
> No window classes registered by a DLL are unregistered when the DLL is unloaded. A DLL must explicitly unregister its classes when it is unloaded.

[WNDCLASSEXA (winuser.h) - Win32 apps | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-wndclassexa)

```cpp
typedef struct tagWNDCLASSEXA {
  UINT      cbSize;
  UINT      style;
  WNDPROC   lpfnWndProc;
  int       cbClsExtra;
  int       cbWndExtra;
  HINSTANCE hInstance;
  HICON     hIcon;
  HCURSOR   hCursor;
  HBRUSH    hbrBackground;
  LPCSTR    lpszMenuName;
  LPCSTR    lpszClassName;
  HICON     hIconSm;
} WNDCLASSEXA, *PWNDCLASSEXA, *NPWNDCLASSEXA, *LPWNDCLASSEXA;
```

[c++ - Side effects of calling RegisterWindow multiple times with same window class? - Stack Overflow](https://stackoverflow.com/questions/150803/side-effects-of-calling-registerwindow-multiple-times-with-same-window-class)

## Class names
- Length <= 256

[winapi - Is it safe to register an existing windows class with a new name? - Stack Overflow](https://stackoverflow.com/questions/14454148/is-it-safe-to-register-an-existing-windows-class-with-a-new-name)

### Namespaces
- `HINSTANCE`
- `CS_GLOBALCLASS`

[What is the HINSTANCE passed to CreateWindow and RegisterClass used for? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20050418-59/?p=35873)

[Using multiple winio instances in the same process will cause panic - Issue #35 - compio-rs/winio](https://github.com/compio-rs/winio/issues/35)
- [fix(win32): hInstance by Chaoses-Ib - Pull Request #38](https://github.com/compio-rs/winio/pull/38/files)
