# Console
[Console documentation - Windows Console | Microsoft Learn](https://learn.microsoft.com/en-us/windows/console/)

## Console control handlers
[Console Control Handlers - Windows Console | Microsoft Learn](https://learn.microsoft.com/en-us/windows/console/console-control-handlers)

[Events](https://learn.microsoft.com/en-us/windows/console/handlerroutine):
- `CTRL_C_EVENT`: [`Ctrl+C`](https://learn.microsoft.com/en-us/windows/console/ctrl-c-and-ctrl-break-signals)
- `CTRL_BREAK_EVENT`: [`Ctrl+Break`](https://learn.microsoft.com/en-us/windows/console/ctrl-c-and-ctrl-break-signals)
- `CTRL_CLOSE_EVENT`: The console is closed
- `CTRL_LOGOFF_EVENT`
- `CTRL_SHUTDOWN_EVENT`

[Registering a Control Handler Function - Windows Console | Microsoft Learn](https://learn.microsoft.com/en-us/windows/console/registering-a-control-handler-function)
- [`SetConsoleCtrlHandler()`](https://learn.microsoft.com/en-us/windows/console/setconsolectrlhandler)

[c++ - Sending a Ctrl+C to a QProcess on Windows - Stack Overflow](https://stackoverflow.com/questions/64760376/sending-a-ctrlc-to-a-qprocess-on-windows)
> When CTRL+C is input to a console process, system create thread in this process with entry point `CtrlRoutine(dwCtrlEvent)`. This `CtrlRoutine` do next: if process is being debugged - raise [`DBG_CONTROL_C`](https://learn.microsoft.com/en-us/windows/win32/debug/debugging-events) exception, then called registered by `SetConsoleCtrlHandler` callbacks. if no registered callbacks or all it return false - `DefaultHandler` is called, which simply call `ExitProcess(STATUS_CONTROL_C_EXIT)` (*Application Exit by CTRL+C*)

- Exit codes

  Not only `CTRL_C_EVENT` exits with `STATUS_CONTROL_C_EXIT`, but also other events. There is no other `STATUS_CONTROL_*` error code.

  [Inconsistent exitcode for terminated child processes on Windows - Issue #76044 - python/cpython](https://github.com/python/cpython/issues/76044)

  [windows - Why does a non-interactive batch script think I've pressed control-C? - Stack Overflow](https://stackoverflow.com/questions/25444765/why-does-a-non-interactive-batch-script-think-ive-pressed-control-c)

- Timeout

  [c++ - Why does my Windows Console Close Event Handler time out? - Stack Overflow](https://stackoverflow.com/questions/47041407/why-does-my-windows-console-close-event-handler-time-out)

- C

  [c - Windows console application - signal for closing event - Stack Overflow](https://stackoverflow.com/questions/26658707/windows-console-application-signal-for-closing-event)

How does Ctrl+C find and kill the descendant processes? [Console process groups](#console-process-groups).

Generating control events:
- [`GenerateConsoleCtrlEvent()`](https://learn.microsoft.com/en-us/windows/console/generateconsolectrlevent)

  [Sending Ctrl-C signal to another application on Windows | Coding with Titans](https://blog.codetitans.pl/post/sending-ctrl-c-signal-to-another-application-on-windows/)

- `CreateRemoteThread()` + `CtrlRoutine()`

  [c++ - Sending a Ctrl+C to a QProcess on Windows - Stack Overflow](https://stackoverflow.com/questions/64760376/sending-a-ctrlc-to-a-qprocess-on-windows)

## Console process groups
[Console Process Groups - Windows Console | Microsoft Learn](https://learn.microsoft.com/en-us/windows/console/console-process-groups)

> When a process is created with `CREATE_NEW_PROCESS_GROUP` specified, an implicit call to [`SetConsoleCtrlHandler(NULL,TRUE)`](https://learn.microsoft.com/en-us/windows/console/setconsolectrlhandler) is made on behalf of the new process; this means that the new process has CTRL+C disabled. This lets shells handle CTRL+C themselves, and selectively pass that signal on to sub-processes. CTRL+BREAK is not disabled, and may be used to interrupt the process/process group.