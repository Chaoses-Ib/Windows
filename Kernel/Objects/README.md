# Objects
[Handles and objects - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/sysinfo/handles-and-objects)

[The Windows Restart Manager: How It Works Part 1](https://www.crowdstrike.com/blog/windows-restart-manager-part-1/)

## Handle inheritance
[Programmatically controlling which handles are inherited by new processes in Win32 - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20111216-00/?p=8873)

- [`CreateProcessW(bInheritHandles)`](../Processes/README.md#creation)
  
  Rust: [Consider different way of inheriting handles in child processes on Windows - Issue #38227 - rust-lang/rust](https://github.com/rust-lang/rust/issues/38227)
  - [Ability to stop child process from Inheriting Handles - Issue #264 - rust-lang/libs-team](https://github.com/rust-lang/libs-team/issues/264)
    - [Add new `inherit_handles` flag to `CommandExt` trait by michaelvanstraten - Pull Request #115501 - rust-lang/rust](https://github.com/rust-lang/rust/pull/115501)
  - [windows: when creating process with redirected stdio, make parent's std handles not inheritable - Issue #54760 - rust-lang/rust](https://github.com/rust-lang/rust/issues/54760)
  - [Cloned sockets are inherited by child processes on windows - Issue #70719 - rust-lang/rust](https://github.com/rust-lang/rust/issues/70719)
  - ~~[Add a way to limit inheritable handles when spawning child process on Windows by quark-zju - Pull Request #75551 - rust-lang/rust](https://github.com/rust-lang/rust/pull/75551)~~

  Zig: [std.child\_process: opt-in to explicit annotate of all to be inherited handles to prevent leaks on Windows - Issue #14251 - ziglang/zig](https://github.com/ziglang/zig/issues/14251)

- Security attributes
  - [\[Windows\] Way to make child processes inherits parent attributes? - Issue #67616 - rust-lang/rust](https://github.com/rust-lang/rust/issues/67616)