# Child Windows
[Child Windows | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows/win32/winmsg/window-features#child-windows)

[Messages | Microsoft Docs](https://docs.microsoft.com/zh-cn/windows/win32/winmsg/window-features#messages)

## Cross-process/thread
[Is it legal to have a cross-process parent/child or owner/owned window relationship? - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/?p=4683)
> Creating a cross-thread parent/child or owner/owned window relationship implicitly attaches the input queues of the threads which those windows belong to, and this attachment is transitive: If one of those queues is attached to a third queue, then all three queues are attached to each other. More generally, queues of all windows related by a chain of parent/child or owner/owned or shared-thread relationships are attached to each other.
>
> This gets even more complicated when the parent/child or owner/owned relationship crosses processes, because cross-process coordination is even harder than cross-thread coordination. Sharing variables within a process is much easier than sharing variables across processes. On top of that, some window messages are blocked between processes.

[使用 SetParent 跨进程设置父子窗口时的一些问题（小心卡死） - walterlv](https://blog.walterlv.com/post/all-processes-freezes-if-their-windows-are-connected-via-setparent.html) ([CSDN](https://blog.csdn.net/WPwalter/article/details/102775111))

[Win32 embedding usage - Issue #24 - compio-rs/winio](https://github.com/compio-rs/winio/issues/24)
