#import "@local/ib:0.1.0": *
#title[Object Verbs]
Launching Applications，Extending Shortcut Menus

#a[Launching Applications (`ShellExecute`, `ShellExecuteEx`, `SHELLEXECUTEINFO`) - Win32 apps | Microsoft Learn][https://learn.microsoft.com/en-us/windows/win32/shell/launch]

不同于 `CreateProcess`，`ShellExecute` 的 `lpFile` 和 `lpParameters` 必须分开提供，不能合并成命令行。
