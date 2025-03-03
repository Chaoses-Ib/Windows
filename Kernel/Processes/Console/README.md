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

[→Libraries](https://github.com/Chaoses-Ib/Linux/blob/main/Kernel/Exceptions/Signals.md#libraries)

### Sending control events
- [`GenerateConsoleCtrlEvent()`](https://learn.microsoft.com/en-us/windows/console/generateconsolectrlevent)

  [Sending Ctrl-C signal to another application on Windows | Coding with Titans](https://blog.codetitans.pl/post/sending-ctrl-c-signal-to-another-application-on-windows/)

  [Feature request: Ability to programmatically cause `SIGINT` in child node process on Windows - Issue #35172 - nodejs/node](https://github.com/nodejs/node/issues/35172#issuecomment-696362422)

- `CreateRemoteThread()` + `CtrlRoutine()`

  [c++ - Sending a Ctrl+C to a QProcess on Windows - Stack Overflow](https://stackoverflow.com/questions/64760376/sending-a-ctrlc-to-a-qprocess-on-windows)

- Using events to mimic

  Nginx:
  - `SIGQUIT`: `ngx_quit_12345`
  - `SIGTERM`: `ngx_stop_12345`
  - `SIGHUP`: `ngx_reload_12345`
  - `SIGUSR1`: `ngx_reopen_12345`

Rust:
- [sysinfo: Cross-platform library to fetch system information](https://github.com/GuillaumeGomez/sysinfo)
  - Linux
  - [Fix ProcessExt::kill on windows by GuillaumeGomez - Pull Request #263](https://github.com/GuillaumeGomez/sysinfo/pull/263)
- [ctrlc-windows: Send a CTRL-C event to a Windows console application](https://github.com/thefrontside/ctrlc-windows/tree/v2)
  - Child process
- ~~[deno_process](https://github.com/denoland/deno/tree/main/ext/process)~~
  
  [feat(runtime/signal): implement SIGINT and SIGBREAK for windows by GJZwiers - Pull Request #14694 - denoland/deno](https://github.com/denoland/deno/pull/14694)

  [refactor(runtime/signal): revert SIGINT and SIGBREAK \`Deno.kill\` Windows changes by dsherret - Pull Request #14865 - denoland/deno](https://github.com/denoland/deno/pull/14865)

  [Reland `Deno.kill` SIGBREAK Windows changes - Issue #14866 - denoland/deno](https://github.com/denoland/deno/issues/14866)
- [iceoryx2/iceoryx2-pal/posix/src/windows/signal.rs](https://github.com/ekxide/iceoryx2/blob/3d5f9426d1aba130c637d9c14589841eb0412a6e/iceoryx2-pal/posix/src/windows/signal.rs#L23)
- [garden/garden-sea/src/terminate.rs](https://github.com/garden-io/garden/blob/86340df8a67ff856c347b78a1f2285d4876a8ac4/garden-sea/src/terminate.rs)
- [Support sending signals on Windows - Issue #219 - watchexec/watchexec](https://github.com/watchexec/watchexec/issues/219)
- ~~[Windows support by qnighy - Pull Request #18 - vorner/signal-hook](https://github.com/vorner/signal-hook/pull/18)~~
- ~~[Add signal possibility on unix by faern - Pull Request #13 - oconnor663/shared\_child.rs](https://github.com/oconnor663/shared_child.rs/pull/13)~~

## Console process groups
[Console Process Groups - Windows Console | Microsoft Learn](https://learn.microsoft.com/en-us/windows/console/console-process-groups)

> When a process is created with `CREATE_NEW_PROCESS_GROUP` specified, an implicit call to [`SetConsoleCtrlHandler(NULL,TRUE)`](https://learn.microsoft.com/en-us/windows/console/setconsolectrlhandler) is made on behalf of the new process; this means that the new process has CTRL+C disabled. This lets shells handle CTRL+C themselves, and selectively pass that signal on to sub-processes. CTRL+BREAK is not disabled, and may be used to interrupt the process/process group.