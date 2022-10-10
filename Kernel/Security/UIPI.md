# User Interface Privilege Isolation
The Windows messaging subsystem honors integrity levels to implement User Interface 
Privilege Isolation (UIPI).[^winter] UIPI prevents lower privilege processes from accessing higher privilege processes by blocking the following behavior[^vista]:

- Perform a window handle validation of higher process privilege.
- SendMessage or PostMessage to higher privilege application windows.
  
  These APIs return success but silently drop the window message. The following informational messages are exceptions:
  - WM_NULL
  - WM_MOVE
  - WM_SIZE
  - WM_GETTEXT
  - WM_GETTEXTLENGTH
  - WM_GETHOTKEY
  - WM_GETICON
  - WM_RENDERFORMAT
  - WM_DRAWCLIPBOARD
  - WM_CHANGECBCHAIN
  - WM_THEMECHANGED
  
  Processes (running with medium or higher integrity level only) can choose to allow additional messages to pass the guard by calling the `ChangeWindowMessageFilterEx` API. An older API, `ChangeWindowMessageFilter`, performs a similar function, but it is per-process rather than per-window.[^winter]
- Use window hooks (`SetWindowsHookEx` API) to attach to a higher privilege process.
  
  For example, a standard user process can’t log the keystrokes the user types into an administrative application.[^winter]
- Use Journal hooks to monitor a higher privilege process.
- Perform DLL injection to a higher privilege process.

With UIPI enabled, the following shared USER resources are still shared between processes at different privilege levels[^vista]:
- Desktop window, which actually owns the screen surface
- Desktop heap read-only shared memory
- Global atom table
- Clipboard

  However, there were some restrictions implemented in the clipboard API. Specifically, `GetClipboardData` and `EnumClipboardFormats` were updated to prevent the caller from reading/enumerating untrusted clipboard formats when the content was copied to the clipboard by a process running in a different integrity level (IL) band.
  
   There are trusted standard clipboard formats that the system allows to cross IL bands, including `CF_TEXT`, `CF_UNICODETEXT`, `CF_BITMAP`, etc. The complete list of trusted formats are stored in the registry under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\UIPI\Clipboard\ExceptionFormats`. There does not appear to be any mechanism to override this behavior or to mark registered clipboard formats as trusted.[^clipboard-format]

Because accessibility applications such as the On-Screen Keyboard (`Osk.exe`) are subject to UIPI’s restrictions (which would require the accessibility application to be executed for each kind of visible integrity-level process on the desktop), these processes can enable UI access. This flag can be present in the manifest file of the image and will run the process at a slightly higher integrity level than medium (between 0x2000 and 0x3000) if launched from a standard user account, or at high integrity level if launched from an Administrator account. Note that in the second case, an elevation request won’t actually be displayed. For a process to set this flag, its image must also 
be signed and in one of several secure locations, including `%SystemRoot%` and `%ProgramFiles%`.[^winter]

[^winter]: Windows Internals
[^vista]: [What is User Interface Privilege Isolation (UIPI) on Vista | Microsoft Learn](https://learn.microsoft.com/en-us/archive/blogs/vishalsi/what-is-user-interface-privilege-isolation-uipi-on-vista)
[^clipboard-format]: [Clipboard: unable to enum registered clipboard formats as Local System](https://social.msdn.microsoft.com/Forums/en-US/5a85a9a6-88a3-4cba-8b19-31c979eea7fa/clipboard-unable-to-enum-registered-clipboard-formats-as-local-system?forum=vcgeneral)