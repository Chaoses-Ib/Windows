#import "@local/ib:0.1.0": *
#title[Wine Debugging]
#a[Debugging Wine - Wiki - wine / wine - GitLab][https://gitlab.winehq.org/wine/wine/-/wikis/Wine-Developer's-Guide/Debugging-Wine]

#a[Wine Environment Variables - simpler-website][https://simpler-website.pages.dev/html/2021/1/wine-environment-variables/]

= ```sh WINEDEBUG``` channels
#q[
To make it easier for people to track down the causes behind each bug, Wine provides a number of debug channels that you can tap into.

Each debug channel, when activated, will trigger logging messages to be displayed to the console where you invoked `wine`.
From there you can redirect the messages to a file and examine it at your leisure.
But be forewarned! Some debug channels can generate incredible volumes of log messages.
Among the most prolific offenders are `relay` which spits out a log message every time a win32 function is called, `win` which tracks windows message passing, and of course `all` which is an alias for every single debug channel that exists.
For a complex application, your debug logs can easily top 1 MB and higher.
A `relay` trace can often generate more than 10 MB of log messages, depending on how long you run the application.
(You'll want to check out `RelayExclude` registry key to modify what the `relay` trace reports).
Logging does slow down Wine quite a bit, so don't use `WINEDEBUG` unless you really do want log files.

Within each debug channel, you can further specify a message class, to filter out the different severities of errors.
The four message classes are: `trace`, `fixme`, `warn`, `err`.

To turn on a debug channel, use the form `class+channel`.
To turn it off, use `class-channel`.
To list more than one channel in the same `WINEDEBUG` option, separate them with commas.
For example, to request `warn` class messages in the `heap` debug channel, you could invoke `wine` like this:
```sh
WINEDEBUG=warn+heap wine program_name
```

If you leave off the message class, Wine will display messages from all four classes for that channel:
```sh
WINEDEBUG=heap wine program_name
```

If you wanted to see log messages for everything except the `relay` channel, you might do something like this:
```sh
WINEDEBUG=+all,-relay wine program_name
```

You can find a list of the debug channels and classes at #a[Debug Channels][/wine/wine/-/wikis/Debug-Channels].
More channels will be added to (or subtracted from) later versions.

For more details about debug channels, check out the #a[Wine Developer's Guide][/wine/wine/-/wikis/Wine-Developer's-Guide].
]

= DLL overrides
#a-badge[https://gitlab.winehq.org/wine/wine/-/wikis/Wine-User's-Guide#dll-overrides]

#q[
It's not always possible to run an application on builtin DLLs, so sometimes native versions will be recommended as a workaround for a specific problem.
Some may be directly copied to the directory configured as `c:\windows\system32` (more on that in the drives section) while others may require an installer, see the next section on *winetricks*.

Native versions of these DLLs do *not* work: `kernel32.dll`, `gdi32.dll`, `user32.dll`, and `ntdll.dll`.
These libraries require low-level Windows kernel access that simply doesn't exist within Wine.

With that in mind, once you've copied the DLL you just need to tell Wine to try to use it.
You can configure Wine to choose between native and builtin DLLs at two different levels.
If you have *Default Settings* selected in the Applications tab, the changes you make will affect all applications.
Or, you can override the global settings on a per-application level by adding and selecting an application in the Applications tab.

To add an override for `FOO.DLL`, enter `FOO` into the box labeled *New override for library:* and click on the Add button.
To change how the DLL behaves, select it within the *Existing overrides:* box and choose Edit.
By default the new load order will be native Windows libraries before Wine builtin ones (*Native then Builtin*).
You can also choose native only, builtin only, or disable it altogether.

DLLs usually get loaded in the following order:
1.  The directory the program was started from.
2.  The current directory.
3.  The Windows system directory.
4.  The Windows directory.
5.  The `PATH` variable directories.
]

`WINEDLLOVERRIDES`:
- Try to load `comdlg32` and `shell32` as native Windows DLLs first and try the builtin version if the native load fails.
  ```sh
  WINEDLLOVERRIDES="comdlg32,shell32=n,b" wine program_name
  ```
- Try to load the `comdlg32` and `shell32` libraries as native windows DLLs. Furthermore, if an application requests to load `c:\foo\bar\baz.dll` load the builtin library `baz`.
  ```sh
  WINEDLLOVERRIDES="comdlg32,shell32=n;c:\\foo\\bar\\baz=b" wine program_name
  ```

No Known DLLs.

#a[Installing dlls - Linux Gaming][https://linux-gaming.kwindu.eu/index.php/Installing_dlls]

= ```sh LD_PRELOAD```
#a[\[Linux\] simple injection with ```sh LD_PRELOAD```][https://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/wow-memory-editing/276206-linux-simple-injection-ld_preload.html]

#a[WineLib app error - WineHQ Forums][https://forum.winehq.org/viewtopic.php?t=8088]

#a[Wine and ```sh LD_PRELOAD```][https://www.winehq.org/pipermail/wine-devel/2007-November/060698.html]

#a[c - How to preload library with ld\_preload to wine(windows game)? - Stack Overflow][https://stackoverflow.com/questions/73276629/how-to-preload-library-with-ld-preload-to-winewindows-game]
