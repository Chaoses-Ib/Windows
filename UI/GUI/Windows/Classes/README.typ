#import "@local/ib:0.1.0": *
#title[Window Classes]
#md(`
[Create a window - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/learnwin32/creating-a-window#window-classes)

[RegisterClassExW function (winuser.h) - Win32 apps | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registerclassexw)
> No window classes registered by a DLL are unregistered when the DLL is unloaded. A DLL must explicitly unregister its classes when it is unloaded.

[WNDCLASSEXA (winuser.h) - Win32 apps | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-wndclassexa)
`)

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

#a[TN001: Window Class Registration | Microsoft Learn][https://learn.microsoft.com/en-us/cpp/mfc/tn001-window-class-registration]

#a[Side effects of calling `RegisterWindow` multiple times with same window class? - Stack Overflow][https://stackoverflow.com/questions/150803/side-effects-of-calling-registerwindow-multiple-times-with-same-window-class]

By the way, Golang has a test about ```c RegisterWindow()```:
#a[runtime: fix parameter checking in syscall.NewCallback - Chaoses-Ib/golang\@5d5312c][https://github.com/Chaoses-Ib/golang/commit/5d5312c5dd979f8ae37482f0fc938587aeb5a245]
- #q-i[🤣刚发现go还给RegisterClass写了个测试]

= Class names
- Length <= 256

#a[Is it safe to register an existing windows class with a new name? - Stack Overflow][https://stackoverflow.com/questions/14454148/is-it-safe-to-register-an-existing-windows-class-with-a-new-name]

= Namespaces
- `HINSTANCE`
- `CS_GLOBALCLASS`
- ```c RegisterClass()``` with non-null ```c hInstance``` but
  ```c CreateWindow()``` with null ```c hInstance``` actually works.

#md(`
[What is the HINSTANCE passed to CreateWindow and RegisterClass used for? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20050418-59/?p=35873)

[Using multiple winio instances in the same process will cause panic - Issue #35 - compio-rs/winio](https://github.com/compio-rs/winio/issues/35)
- [fix(win32): hInstance by Chaoses-Ib - Pull Request #38](https://github.com/compio-rs/winio/pull/38/files)
`)

```rust
// cargo add windows --features Win32_Foundation,Win32_System_LibraryLoader

/// Get the handle of the current executable or DLL.
///
/// Ref: https://github.com/compio-rs/winio/issues/35
pub fn get_current_module_handle() -> HMODULE {
    let mut module = HMODULE::default();
    _ = unsafe {
        GetModuleHandleExW(
            GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
            PCWSTR(get_current_module_handle as *const _),
            &mut module,
        )
    };
    module
}
```

= Built-in classes
Do we really need ```c RegisterClass()``` for a top-level window instead of
just subclassing a built-in class?
#footnote[#a[c++ - Why is it necessary to `RegisterClass` in Windows API programming? - Stack Overflow][https://stackoverflow.com/questions/24534141/why-is-it-necessary-to-registerclass-in-windows-api-programming]]
- ```c hInstance``` and ```c UnregisterClass()``` is troublesome to deal with for DLL.
  #footnote[#a[winapi - How to call and use `UnregisterClass`? - Stack Overflow][https://stackoverflow.com/questions/29654139/how-to-call-and-use-unregisterclass]]

Yes, this can actually work.
- ```c WC_STATIC``` is probably the most suitable one.
  #footnote[#a[c++ - Using `CreateWindowEx` to Make a Message-Only Window - Stack Overflow][https://stackoverflow.com/questions/4081334/using-createwindowex-to-make-a-message-only-window]]
  #footnote[#a[feat(ipc/wm): replace `RegisterClass()` with `WC_STATIC` - Chaoses-Ib/ib-everything\@476fdd4][https://github.com/Chaoses-Ib/ib-everything/commit/476fdd410de817e0fa6420d581b8e39f3cd12c3f]]
  #footnote[#a[feat(windows/shell): replace `RegisterClass()` with `WC_STATIC` - Chaoses-Ib/ib-hook\@8fddee9][https://github.com/Chaoses-Ib/ib-hook/commit/8fddee91b31206dbbb557d605554b491d40644e3]]

- ```c CreateDialog()```/```c WC_DIALOG``` can also be used.
  #footnote[#a[c - Create Window without Registering a `WNDCLASS`? - Stack Overflow][https://stackoverflow.com/questions/10232221/create-window-without-registering-a-wndclass]]

- Further, if you don't care ```c SendMessage()```,
  just handling the messages in the message loop (from ```c GetMessage()```) is enough.
  No need for subclassing.

= Subclassing
#a[Using Window Procedures - Win32 apps | Microsoft Learn][https://learn.microsoft.com/en-us/windows/win32/winmsg/using-window-procedures#subclassing-a-window]

#a[Q76947 - HOWTO: Extend Standard Windows Controls Through Superclassing][https://helparchive.huntertur.net/document/108381]
