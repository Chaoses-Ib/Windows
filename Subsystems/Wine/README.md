# [Wine](https://www.winehq.org/)
[Wikipedia](https://en.wikipedia.org/wiki/Wine_(software)), [GitHub](https://github.com/wine-mirror/wine)

Wine is another implementation of the Windows subsystem, based on different kernels.

Kernels: Linux, FreeBSD, ReactOS, macOS, Android

[How Wine works 101 🍷 | Andy Hippo](https://werat.dev/blog/how-wine-works-101/)

[WineHQ - Wine Application Database](https://appdb.winehq.org/)

## Versions
- CrossOver
- [ValveSoftware/wine: Wine with a bit of extra spice](https://github.com/ValveSoftware/wine)
  - [Proton](https://github.com/ValveSoftware/Proton) ([Wikipedia](https://github.com/ValveSoftware/Proton))
- WINE@Etersoft

[Other versions of Wine - Wikipedia](https://en.wikipedia.org/wiki/Wine_(software)#Other_versions_of_Wine)

[What is best version of Wine? : r/linux\_gaming](https://www.reddit.com/r/linux_gaming/comments/cn2jym/what_is_best_version_of_wine/)

## ReactOS
[WINE - ReactOS Wiki](https://reactos.org/wiki/WINE)
> ReactOS works with the WINE project to share as much programming effort as possible. ReactOS depends on Wine mainly for [user mode DLLs](http://svn.reactos.org/svn/reactos/trunk/reactos/media/doc/README.WINE?view=markup). Where appropriate, patches to Wine are also submitted by the development team, and patch contributors are often directed to Wine if it is felt that the patches would benefit them.
>
> However, due to architectural differences arising from Wine targetting the Linux platform, some of their DLLs may not be used on ReactOS without specific modifications. As an example, kernel32.dll and gdi32.dll have to be forked, since the Wine versions effectively redirect calls to the Linux kernel and X server respectively. More recently (November 2009) however a research effort has been made to bring the ReactOS architecture closer to Wine's in order that more of their code can be used without modifications. This is currently being done in the [Arwinss](https://reactos.org/wiki/Arwinss) branch.

## Linux
[Debian/Ubuntu - Wiki - wine / wine - GitLab](https://gitlab.winehq.org/wine/wine/-/wikis/Debian-Ubuntu)
- `sudo dpkg --add-architecture i386` is not optional

2 GiB

### WSL2
~~Note that WSL will take precedence over Wine. One must use `wine a.exe` to run the program.~~

[Wine Running on Windows with the Windows Subsystem for Linux | Hacker News](https://news.ycombinator.com/item?id=13603451)

[\> I installed Wine in Ubuntu running in WSL on a Windows 11 machine, and the gam... | Hacker News](https://news.ycombinator.com/item?id=38909304)

[I got wine to run on WSL : r/bashonubuntuonwindows](https://www.reddit.com/r/bashonubuntuonwindows/comments/5kkg2i/i_got_wine_to_run_on_wsl/)

```c
0044:err:vulkan:vulkan_init_once Failed to load libvulkan.so.1
00c4:err:ntoskrnl:ZwLoadDriver failed to create driver L"\\Registry\\Machine\\System\\CurrentControlSet\\Services\\winebth": c00000e5
003c:fixme:service:scmdatabase_autostart_services Auto-start service L"winebth" failed to start: 1359

0128:fixme:unwind:RtlVirtualUnwind2 unknown unwind info version 0 at 0000000140C1D0D0
0128:fixme:unwind:RtlVirtualUnwind2 unknown unwind info version 0 at 0000000140C1D0D0
...
0128:fixme:unwind:RtlVirtualUnwind2 unknown unwind info version 0 at 0000000140C1D0D0
0128:fixme:unwind:RtlVirtualUnwind2 unknown unwind info version 0 at 0000000140C1D0D0
0128:fixme:unwind:RtlVirtualUnwind2 stack overflow 4672 bytes addr 0x6fffffc62d03 stack 0x7ffffe0ffdc0 (0x7ffffe100000-0x7ffffe101000-0x7ffffe200000)
```

Entry point:
```c
wine: Unhandled page fault on write access to 0000000000000000 at address 00000001408AF024 (thread 012c), starting debugger...
```

```c
0158:err:virtual:virtual_setup_exception stack overflow 1792 bytes addr 0x6ffffe7d18c3 stack 0x7ffffe100900 (0x7ffffe100000-0x7ffffe101000-0x7ffffe200000)
```
[help needed with WSL2 wine : r/wine\_gaming](https://www.reddit.com/r/wine_gaming/comments/xov1zi/help_needed_with_wsl2_wine/)

### Docker
- [scottyhardy/docker-wine: Docker image that includes Wine and Winetricks for running Windows applications on Linux and macOS](https://github.com/scottyhardy/docker-wine)
  - 1.1G
- [tobix/wine - Docker Image | Docker Hub](https://hub.docker.com/r/tobix/wine)
  - 0.8G
- [suchja/wine: Docker image providing the latest stable version of Wine. Can be used with suchja/x11server.](https://github.com/suchja/wine) (discontinued)
  - 0.2G
  - [amake/wine Tags | Docker Hub](https://hub.docker.com/r/amake/wine/tags)

Headless:
- [benjymous/docker-wine-headless: A docker image that runs a combination of Wine32 and xvfb to allow testing Windows apps in a headless environment](https://github.com/benjymous/docker-wine-headless) (discontinued)
  - 0.2G

[How can I get my Win32 app running with Wine in Docker? - Stack Overflow](https://stackoverflow.com/questions/61815364/how-can-i-get-my-win32-app-running-with-wine-in-docker)

## System calls
2020-06 [Emulating Windows system calls in Linux \[LWN.net\]](https://lwn.net/Articles/824380/)

[Why can Wine convert Windows systemcall to Linux systemcall? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/731441/why-can-wine-convert-windows-systemcall-to-linux-systemcall)

2024-11-06 [ntdll: Add SIGSYS handler to support syscall emulation on macOS Sonoma and later. (!6777) - Merge requests - wine / wine - GitLab](https://gitlab.winehq.org/wine/wine/-/merge_requests/6777)

## Rust
~~[Regression: `File::open` not falling back to `FileEndOfFileInfo` on WINE - Issue #135831 - rust-lang/rust](https://github.com/rust-lang/rust/issues/135831)~~
```rust
thread 'main' panicked at library\std\src\sys\pal\windows\fs.rs:332:29:
FILE_ALLOCATION_INFO failed!!!
```

## CLI
[wineconsole(1): Wine console - Linux man page](https://linux.die.net/man/1/wineconsole)

[Wine Environment Variables - simpler-website](https://simpler-website.pages.dev/html/2021/1/wine-environment-variables/)

[`winedbg`](https://linux.die.net/man/1/winedbg)
- `winedbg --command "info proc"`

  [process - How to list wine processes on the terminal screen? - Stack Overflow](https://stackoverflow.com/questions/41227121/how-to-list-wine-processes-on-the-terminal-screen)
