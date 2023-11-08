# [Registry](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry)
The **registry** is a system-defined database in which applications and system components store and retrieve configuration data.

## [Hives](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry-hives)
A **hive** is a logical group of keys, subkeys, and values in the registry that has a set of supporting files loaded into memory when the operating system is started or a user logs in.

## Links
[Creating Registry Links -- Pavel Yosifovich](https://scorpiosoftware.net/2020/07/17/creating-registry-links/)

## Virtualization
- [Registry Virtualization](https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry-virtualization)
- [RegOverridePredefKey()](https://docs.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regoverridepredefkey)
- Hooking
  - [Sandboxie](https://github.com/sandboxie-plus/Sandboxie)
    
    [Sandbox Hierarchy](https://sandboxie-plus.com/sandboxie/sandboxhierarchy/)
  - [WinPriv](https://github.com/NoMoreFood/WinPriv)
    
    WinPriv is a utility that can enable privileges and virtually alter registry settings within a target process, amongst other things.

## Performance
> The cost of opening a key, reading a value, and closing it is around 60,000 to 100,000 cycles (~30µs) (I’m told). And that’s assuming the key you’re looking for is in the cache. If you open the key and hold it open, then the act of reading a value costs around 15,000 to 20,000 cycles (~5µs). (These numbers are estimates for Windows XP; actual mileage may vary.) Consequently, you shouldn’t be reading a registry key in your inner loop.
> 
> If you need to worry about somebody changing the value while your program is running, you can establish a protocol for people to follow when they want to change a setting. If you can’t establish a mechanism for coordinating changes to the setting, you can set a change notification via the [RegNotifyChangeKeyValue()](https://docs.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regnotifychangekeyvalue) function so that you are notified when the value changes.[^perf-raymond]

[Windows registry performance in multithreading | Mechanics of software](https://www.arbinada.com/en/node/1650)

[^perf-raymond]: [The performance cost of reading a registry key - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20060222-11/?p=32193)

## Tools
- Registry Editor
- [Registry Workshop](http://www.torchsoft.com/en/rw_information.html)
- [Windows Registry Tools](https://www.nirsoft.net/windows_registry_tools.html)
  - [RegDllView](https://www.nirsoft.net/utils/registered_dll_view.html)