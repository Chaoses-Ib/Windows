# Child Windows
[Child Windows | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows/win32/winmsg/window-features#child-windows)

[Messages | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows/win32/winmsg/window-features#messages)

## Parent windows
APIs:
- [GetParent function (winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getparent)

  > If the window is a child window, the return value is a handle to the parent window. If the window is a top-level window with the `WS_POPUP` style, the return value is a handle to the owner window.

- [GetAncestor function (winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getancestor)
  - `GA_ROOT` doesn't include Desktop, but `GA_PARENT` includes

    [c++ - GetAncestor behaving weirdlly - Stack Overflow](https://stackoverflow.com/questions/64705850/getancestor-behaving-weirdlly)

- [GetWindow function (winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindow)

## Cross-process/thread
[Is it legal to have a cross-process parent/child or owner/owned window relationship? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/?p=4683)
> Creating a cross-thread parent/child or owner/owned window relationship implicitly attaches the input queues of the threads which those windows belong to, and this attachment is transitive: If one of those queues is attached to a third queue, then all three queues are attached to each other. More generally, queues of all windows related by a chain of parent/child or owner/owned or shared-thread relationships are attached to each other.
>
> This gets even more complicated when the parent/child or owner/owned relationship crosses processes, because cross-process coordination is even harder than cross-thread coordination. Sharing variables within a process is much easier than sharing variables across processes. On top of that, some window messages are blocked between processes.

Considering all top windows are child windows of Desktop, it's actually more natural that cross-process child windows are supported.

[使用 SetParent 跨进程设置父子窗口时的一些问题（小心卡死） - walterlv](https://blog.walterlv.com/post/all-processes-freezes-if-their-windows-are-connected-via-setparent.html) ([CSDN](https://blog.csdn.net/WPwalter/article/details/102775111))

[Win32 embedding usage - Issue #24 - compio-rs/winio](https://github.com/compio-rs/winio/issues/24)
