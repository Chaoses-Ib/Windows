# Common Controls
[Windows Controls - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/window-controls)

[The history of the Windows XP common controls - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20080129-00/?p=23663)

[Common Control Fundamentals](https://sinis.ro/static/ch16b.htm)

[dotnet/winforms: Windows Forms is a .NET UI framework for building Windows desktop applications.](https://github.com/dotnet/winforms)

Using common control class directly without loading `ComCtl32.dll`?
- [`USER` controls](#user-controls)

[Uncommon Controls](https://www.luigibianchi.com/uncommon_controls.htm)

## `USER` controls
Available from Win16.

- `BUTTON`, `EDIT`, `LISTBOX`, `COMBOBOX`, `STATIC` and `SCROLLBAR`
- `user32.dll`

> 核心组件存根里写了 v6 是 comctl32.dll 里的，不写是 user32.dll 里的，是 XP 时候为了保持类名不变加的屎

[winapi - Are all controls in Windows called common controls? - Stack Overflow](https://stackoverflow.com/questions/26882415/are-all-controls-in-windows-called-common-controls)

[c - Is a "BUTTON" a common control? - Stack Overflow](https://stackoverflow.com/questions/33312287/is-a-button-a-common-control)

## Common control v1~5
[Common Controls Replacement Project](http://ccrp.mvps.org/index.html?support/faqs/faqcomctl32.htm)

## Common control v6
`USER` controls + common controls

> More brainstorming ensued, and a Plan C emerged. The common controls library would take advantage of [side-by-side assemblies](http://msdn2.microsoft.com/en-gb/library/aa375193.aspx) and use the application manifest to control which DLL a given window class name would resolve to. Thus was born a new DLL also called `COMCTL32`, but with a new version number---version 6. Old programs would get version 5.82 just like they did in Windows 2000. New programs would have to use a manifest to specify that they wanted version 6.

[Common Control Versions - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/common-control-versions)

[Enabling Visual Styles - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/cookbook-overview)
