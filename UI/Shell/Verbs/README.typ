#import "@local/ib:0.1.0": *
#title[Object Verbs]
Launching Applications，Extending Shortcut Menus

The Unix way, i.e. CLI (command palette), is probably a better way.

#a[Verbs and File Associations ((Windows Explorer and Controls))][https://web.archive.org/web/20030724203114/http://msdn.microsoft.com/library/en-us/shellcc/platform/shell/programmersguide/shell_basics/shell_basics_extending/fileassociations/fa_verbs.asp?frame=true]

#a[Launching Applications (`ShellExecute`, `ShellExecuteEx`, `SHELLEXECUTEINFO`) - Win32 apps | Microsoft Learn][https://learn.microsoft.com/en-us/windows/win32/shell/launch]

= `ShellExecute`
- #a[`ShellExecuteW`][https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecutew]
- #a[`ShellExecuteExW`][https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecuteexw]

不同于 `CreateProcess`，`ShellExecute` 的 `lpFile` 和 `lpParameters` 必须分开提供，不能合并成命令行。

XP SP1:
```rs
ShellExecuteEx() {
  ShellExecuteNormal() {
    CShellExecute *shex = new CShellExecute();
    shex->ExecuteNormal(pei) {
      try {
        _PerfPidl(&pidl)?;

        // If the specified filename is a UNC path, validate it now.
        _TryValidateUNC(_szFile, pei, pidl)?;

        _TryHooks(pei)?;

        _TryExecPidl(pei, pidl)? {
          _ShellExecPidl() {
            SHGetUIObjectFromFullPIDL(pidlExec, pei->hwnd, IID_PPV_ARG(IContextMenu, &pcm))?;
            _InvokeInProcExec(pcm, pei)
          }
        }

        // Is the class key provided?
        _InitAssociations(pei, pidl)? {
          if !_InitClassAssociations() {
            if PathIsExe(_szFile) {
              _fTryOpenExe = true;
            } else {
              _ReportWin32(ERROR_NO_ASSOCIATION)
            }
          }
        }

        _TryInvokeApplication(_fDDEWait || (pei->fMask & SEE_MASK_NOCLOSEPROCESS));
      } finally {
        if _fTryOpenExe {
          _TryOpenExe() {
            // this is the last chance that a file will have
            // we shouldnt even be here in any case
            // unless the registry has been thrashed, and
            // the exe classes are all deleted from HKCR
          }
        }
        if _err == ERROR_SUCCESS && UEMIsLoaded() {
          // skip the call if stuff isn't there yet.
          // the load is expensive (forces ole32.dll and browseui.dll in
          // and then pins browseui).

          // however we ran the app (exec, dde, etc.), we succeeded.  do our
          // best to guess the association etc. and log it.
          int i = GetUEMAssoc(_szFile, _szImageName, _lpID);
          UEMFireEvent(&UEMIID_SHELL, UEME_INSTRBROWSER, UEMF_INSTRUMENT, UIBW_RUNASSOC, (LPARAM)i);
        }
      }
    }
  }
}
```

= Hooks
- `IShellExecuteHook` (deprecated)
- Registry
- `IContextMenu`

XP SP1:
```rs
// REARCHITECT: the only client of this are URLs.
// if we change psfInternet to return IID_IQueryAssociations,
// then we can kill the urlexechook  (our only client)
```

#a[What were ShellExecute hooks designed for? - The Old New Thing][https://devblogs.microsoft.com/oldnewthing/20080910-00/?p=20933]
#quote(block: true)[
Since shell execute hooks effectively become part of the `ShellExecute` function, they are unwittingly subject to all the application compatibility constraints that `ShellExecute` must follow. Welcome to the operating system. Your world has just gotten a lot more complicated.

There is no "list of application compatibility constraints" (oh how life would be simple if there were); basically, anything that `ShellExecute` did in the past is a de facto compatibility constraint. Some programs crash if you create a worker thread inside `ShellExecute`; other programs crash if you call `PeekMessage` inside `ShellExecute`. Some programs call `ShellExecute` and #a[immediately exit][http://blogs.msdn.com/oldnewthing/archive/2004/11/26/270710.aspx], which means that your shell execute hook had better not return before its work is done (or at least before the work has been given to another process to finish). Some programs call `ShellExecute` on an unusually small stack, so you have to watch your stack usage. And even though it is called out in the documentation that programs should not call shell functions from inside `DllMain`, that doesn't stop people from trying, anyway. Your shell execute hook had better behave in a sane manner when called under such "impossible" conditions.
]

#a[Is IShellExecuteHook not supported in Vista?][https://groups.google.com/g/microsoft.public.platformsdk.shell/c/ixdOX1--IKk]
#quote(block: true)[
Previously we've encountered many app compatibility problems regarding this
interface, therefore it's currently disabled by default on Vista with a
policy control:

You can turn it on by enabling `POLID_EnableShellExecuteHooks`. Set this
under
`[HKLM|HKCU]\Softwaren\Microsoft\Windows\CurrentVersion\Policies\Explorer
EnableShellExecuteHooks=<DWORD>1`.

After that, you still need to add the CLSID under

`HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks`
]
#quote(block: true)[
The problem is that the `open` verb on Folders can't be overridden without
admin/elevated permissions. Creating an 'open' verb in
`HKEY_CURRENT_USER\Software\Classes` _should_ work but doesn't - Explorer
ignores this and keeps using the 'open' verb from `HKEY_LOCAL_MACHINE`.

What we do is create our own verb under `HKEY_CURRENT_USER`, and set that as
the default action. For the most part this works ok, except when
`ShellExecute()` is called for a folder with the verb actually specified as
`open` instead of `NULL` for the default. In these instances, it is necessary
to use a `ShellExecute` hook to trap it.

Perhaps you could find out why Explorer ignores the `open` verb from
`HKEY_CURRENT_USER`? According to the docs, "If the values of entries in the
two Classes subkeys conflict, then only the value in
`HKEY_CURRENT_USER\SOFTWARE\Classes` appears in `HKEY_CLASSES_ROOT`.", so (imho)
you could say this is a bug.
]
#quote(block: true)[
I added the following registry entries on my Windows XP Service Pack 2
machine, and it had the effect I believe you are looking for:

- `HKCR\Folder\shell\(default)=test`
- `HKCR\Folder\shell\test\command\(default)=Notepad.exe`

It makes "test" the default verb and so double-clicking on a folder in a
shell view opens Notepad.

Unfortunately, so does clicking a folder menu item in the Start Menu, such
as My Computer or My Pictures.

You can presumably achieve a similar thing with more control using a context
menu handler.
]
