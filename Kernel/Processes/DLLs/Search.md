# DLL Search Order
[Dynamic-link library search order - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order)
- 如果同名 DLL 已存在就不再加载（即使目录不一样）
- *即使加载时指定了路径，加载子依赖 DLL 时依然会只用名称进行搜索*
  - 跨目录加载 DLL 时应使用 `SetDllDirectory` 或者 `LOAD_WITH_ALTERED_SEARCH_PATH`
- `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs`
- `SafeDllSearchMode`（默认，当前<系统）
  1. 程序所在目录
  2. `GetSystemDirectory`
  3. `GetWindowsDirectory`
  4. `GetCurrentDirectory`
  5. `PATH`
- Not `SafeDllSearchMode`（当前>系统）
  1. 程序所在目录
  2. *`GetCurrentDirectory`*
  3. `GetSystemDirectory`
  4. `GetWindowsDirectory`
  5. `PATH`

`HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\SafeDllSearchMode`

If safe DLL search mode is enabled, then the search order is as follows:
1. [DLL redirection](#dll-redirection)
2. API sets.
3. SxS manifest redirection.
4. Loaded-module list.
5. Known DLLs.
6. **Windows 11, version 21H2 (10.0; Build 22000), and later**. The package dependency graph of the process. This is the application's package plus any dependencies specified as `<PackageDependency>` in the `<Dependencies>` section of the application's package manifest. Dependencies are searched in the order they appear in the manifest.
7. The folder from which the application loaded.
8. The system folder. Use the [**GetSystemDirectory**](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemdirectorya) function to retrieve the path of this folder.
9. The 16-bit system folder. There's no function that obtains the path of this folder, but it is searched.
10. The Windows folder. Use the [**GetWindowsDirectory**](https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getwindowsdirectorya) function to get the path of this folder.
11. The current folder.
12. The directories that are listed in the `PATH` environment variable. This doesn't include the per-application path specified by the **App Paths** registry key. The **App Paths** key isn't used when computing the DLL search path.

## [DLL redirection](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-redirection)
`example.exe.local`

If the app has an application manifest:
```bat
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /v DevOverrideEnable /t REG_DWORD /d 1
```
And reboot.

Cannot be directly used for DLL hijacking: loading the original DLL with absolute path will actually load the hijacked one. With export forwarding, this will even lead to infinite load and get `0xc000007b` error.
- Copy the original DLL and rename it.
- Copy the original DLL and patch it.
  - Compatibility problem
- API sets
- Hook `LoadLibrary()`

[DLL/COM Redirection on Windows - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/sbscs/dll-com-redirection-on-windows)

[Why is DotLocal redirection applied even if the exe has a manifest - Stack Overflow](https://stackoverflow.com/questions/55668163/why-is-dotlocal-redirection-applied-even-if-the-exe-has-a-manifest)

## API sets
### API set overriding

## SxS manifest redirection
[DLL redirection using manifests - Stack Overflow](https://stackoverflow.com/questions/2100973/dll-redirection-using-manifests)
> Basically when the executable is loaded Windows collects all the related manifests that are linked using the identity and dependency elements. Then for each `file` element contained in the manifest files, it adds an entry into the activation context:
> ```c
> 'name attribute of file element' -> 'absolute path of manifest file' + 'name attribute of file element'
> ```
> Now when a load library call is made, it searches the activation context map for a key that matches the path argument of load library, and then calls `Loadlibrary` with the value for that key.

[DLL file loaded twice with DLL redirection through manifest - Stack Overflow](https://stackoverflow.com/questions/2147729/dll-file-loaded-twice-with-dll-redirection-through-manifest/5423561)
```xml
<?xml version='1.0' encoding='UTF-8' standalone='yes'?>
<assembly xmlns='urn:schemas-microsoft-com:asm.v1' manifestVersion='1.0'>
    <file name="python25.dll" />
</assembly>
```

[Intercepted: Windows Hacking via DLL Redirection - EH-Net Online Mag](https://web.archive.org/web/20150915101918/https://www.ethicalhacker.net/columns/heffner/intercepted-windows-hacking-via-dll-redirection)

[Side-by-side assembly - Wikipedia](https://en.wikipedia.org/wiki/Side-by-side_assembly)

[c# - How to provide a private Side by Side manifest that correctly locates a .NET Dll as COM Provider? - Stack Overflow](https://stackoverflow.com/questions/48272723/how-to-provide-a-private-side-by-side-manifest-that-correctly-locates-a-net-dll)

## Known DLLs
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs`

[KnownDLLs](KnownDLLs.reg)

## Alternate Search Order
`LoadLibraryEx` with `LOAD_WITH_ALTERED_SEARCH_PATH`

相当于将“程序所在目录”替换为了指定的目录

## SetDllDirectory
- `SetDllDirectory`、`AddDllDirectory`
- *子进程会继承父进程的 `SetDllDirectory`*
- 调用 `SetDllDirectory` 会关闭 `SafeDllSearchMode`
- 顺序：
  1. 程序所在目录
  2. `GetDllDirectory`
  3. `GetSystemDirectory`
  4. `GetWindowsDirectory`
  5. `PATH`
- `SetDllDirectory` 会取消掉对 `CurrentDirectory` 的搜索？

## Security
[Dynamic-Link Library Security - Win32 apps | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-security)
- 调用 `LoadLibrary`、`CreateProcess`、`ShellExecute` 时应指定路径
- `LoadLibrary` 时使用 flags 控制顺序，或者使用 `SetDllDirectory`
- 考虑使用 DLL redirection 或者 mainfest
- 不要使用 SearchPath 来获取 DLL 的路径，除非开启了 safe process search mode
- 可以使用 Process Monitor 来测验 DLL 加载的安全性

## DLL hijacking
[Triaging a DLL planting vulnerability - Microsoft Security Response Center](https://msrc-blog.microsoft.com/2018/04/04/triaging-a-dll-planting-vulnerability/)

[2019 year-end link clearance: The different kinds of DLL planting | The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20191231-00/?p=103282)

### 劫持方法
**[Adaptive DLL Hijacking -- Silent Break Security](https://silentbreaksecurity.com/adaptive-dll-hijacking/)**

- Export Forwarding（导出转发）

  通过 .def/链接器参数 重定向导出

  可以指定绝对路径（但只有链接器参数支持？）（但不能同时指定名称和序号？）

  [tothi/dll-hijack-by-proxying: Exploiting DLL Hijacking by DLL Proxying Super Easily](https://github.com/tothi/dll-hijack-by-proxying)

  [kevinalmansa/DLL\_Wrapper: A program that generates code to implement a DLL Proxy.](https://github.com/kevinalmansa/DLL_Wrapper)

  C#：[Flangvik/SharpDllProxy: Retrieves exported functions from a legitimate DLL and generates a proxy DLL source code/template for DLL proxy loading or sideloading](https://github.com/Flangvik/SharpDllProxy)

- Run Time Linking（运行时跳转）

  [Yonsm/AheadLib: Fake DLL Source Code Generator](https://github.com/Yonsm/AheadLib)
  - [strivexjun/AheadLib-x86-x64: hijack dll Source Code Generator. support x86/x64](https://github.com/strivexjun/AheadLib-x86-x64)
  - [技术分享 - 基于AheadLib工具进行DLL劫持](https://www.write-bug.com/article/1883.html)

  [blaquee/dll-hijack: A template to hijack version.dll.](https://github.com/blaquee/dll-hijack)

- Stack Patching

  修改 LoadLibrary 返回值，只适用于 LoadLibrary 加载的 DLL。

  [一种通用Dll劫持技术研究 | Anhkgg'Lab | Windows Kernel | Rootkit | Reverse Engineer | Expolit | 内核研究 | 逆向分析 | 漏洞分析挖掘](https://anhkgg.com/dllhijack/)
  - [SuperDllHijack/README-zh\_CN.md at master - anhkgg/SuperDllHijack](https://github.com/anhkgg/SuperDllHijack/blob/master/README-zh_CN.md)

- Run-Time Generation

  动态修改 IAT？

C++:
- [IbDllHijackLib: A C library for Windows DLL hijacking.](https://github.com/Chaoses-Ib/IbDllHijackLib)

Rust:
- [WarrenHood/proxygen: A DLL proxy generator written in Rust.](https://github.com/WarrenHood/proxygen)
  - `#[forward]` is not export forwarding, but just inline asm.
  - `#[proxy]`, `#[pre_hook]`, `#[post_hook]`
- [Kudaes/ADPT: DLL proxying for lazy people](https://github.com/Kudaes/ADPT)
- [Kazurin-775/dll-spoofer-rs: A spoofing / hijacking DLL creator written in Rust](https://github.com/Kazurin-775/dll-spoofer-rs)
- [b1-team/dll-hijack: Dll hijack -- just one macro](https://github.com/b1-team/dll-hijack)
- [aancw/DllProxy-rs: Rust Implementation of SharpDllProxy for DLL Proxying Technique](https://github.com/aancw/DllProxy-rs)
- [0xf00sec/DLLProxying-rs: a simple implementation of Proxy-DLL-Loads in Rust](https://github.com/0xf00sec/DLLProxying-rs)

### Detect
- Process Monitor

  ![](images/Search/ProcessMonitor.png)
- [Dependencies: A rewrite of the old legacy software "depends.exe" in C# for Windows devs to troubleshoot dll load dependencies issues.](https://github.com/lucasg/Dependencies) (inactive)
- [Dependency Walker (depends.exe) Home Page](http://www.dependencywalker.com/) (discontinued)

  分析非常耗时。