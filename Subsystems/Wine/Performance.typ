#import "@local/ib:0.1.0": *
#title[Wine Performance]
= ```sh WINEDEBUG``` channels
#q[Logging does slow down Wine quite a bit, so don't use ```sh WINEDEBUG``` unless you really do want log files.]

```sh
WINEDEBUG=-all wine program_name
```
#footnote[#a[How do I prevent logging/tracing? - WineHQ Forums][https://forum.winehq.org/viewtopic.php?t=34459]]

= Startup latency
Optimizations:
- Persistent ```sh wineserver```

  ```sh
  wineserver -k  # Kill a potential old server
  wineserver -p  # Start a new server
  wine wineboot  # Run a process to start up all background wine processes
  ```
  #footnote[#a[mstorsjo/msvc-wine: Scripts for setting up and running MSVC in Wine on Linux][https://github.com/mstorsjo/msvc-wine#installation]]
- Startup within Wine
- Do not use ```sh wineconsole```

Extra latency compared to native Windows:
- Within Wine: \~10ms.
- From Linux, with ```sh wineserver``` running: \~80ms.
  (\~100ms compared to Linux)
- ```sh wineconsole```: \~160ms.

Linux:
```sh
time hostname
```
```sh
real    0m0.005s
user    0m0.003s
sys     0m0.003s
```

Windows:
```cmd
cmake -E time hostname
```
```cmd
Elapsed time: 0 s. (time), 0.02 s. (clock)
```

Startup within Wine:
#footnote[#a[batch file - How do I measure execution time of a command on the Windows command line? - Stack Overflow][https://stackoverflow.com/questions/673523/how-do-i-measure-execution-time-of-a-command-on-the-windows-command-line]]
```sh
WINEDEBUG='-all' wine cmake.exe -E time hostname
```
```cmd
Elapsed time: 0 s. (time), 0.03 s. (clock)
```

Wine from Linux, with ```sh wineserver``` running:
```sh
time WINEDEBUG='-all' wine hostname
```
```sh
real    0m0.106s
user    0m0.008s
sys     0m0.044s
```

```sh wineconsole```:
```sh
time WINEDEBUG='-all' wineconsole hostname
```
```sh
real    0m0.178s
user    0m0.014s
sys     0m0.035s
```

#a[Speed/latency issues for development in a Wine environment - WineHQ Forums][https://forum.winehq.org/viewtopic.php?t=8675]

#a[Wine startup time - WineHQ Forums][https://forum.winehq.org/viewtopic.php?t=23294]

#a[Faster Wine application opening - Ask Ubuntu][https://askubuntu.com/questions/118318/faster-wine-application-opening]

= ```sh wine-preloader```
#a-badge[https://github.com/wine-mirror/wine/blob/master/loader/preloader.c]

#q[
The goal of this program is to be a workaround for `exec-shield`, as used
by the Linux kernel distributed with Fedora Core and other distros.]

#a[win32-preloader - WineHQ Forums][https://forum.winehq.org/viewtopic.php?t=26938]
