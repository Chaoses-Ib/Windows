# Icons
## [`ExtractIcon`](https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-extracticonw)
### [`ExtractAssociatedIcon`](https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-extractassociatediconw)
```cpp
// Windows XP SP1
HICON WINAPI ExtractAssociatedIcon(HINSTANCE hInst, LPTSTR lpIconPath, WORD *lpiIcon)
{
    HICON hIcon = ExtractIcon(hInst, lpIconPath, *lpiIcon);
    
    if (hIcon == NULL)
        hIcon = SHGetFileIcon(NULL, lpIconPath, 0, SHGFI_LARGEICON);
    if (hIcon == NULL)
    {
        *lpiIcon = IDI_DOCUMENT;
        GetModuleFileName(HINST_THISDLL, lpIconPath, 128);
        hIcon = LoadIcon(HINST_THISDLL, MAKEINTRESOURCE(*lpiIcon));
    }
    
    return hIcon;
}
```

## [`SHGetFileInfo`](https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shgetfileinfow)
```cpp
// Windows XP SP1
SHGetFileInfo() {
    _GetFileInfoSections() {
        Shell_GetImageLists(&himlLarge, &himlSmall) {
            if (!_IsSHILInited())
            {
                // make sure they are created and the right size.
                FileIconInit(fRestoreCache = FALSE) {
                    IconCacheRestore() {
                        GetIconCachePath() {
                            SHGetFolderPath(NULL, CSIDL_LOCAL_APPDATA | CSIDL_FLAG_CREATE, NULL, 0, pszPath);
                            PathAppend(pszPath, TEXT("IconCache.db"));
                        }
                    }
                }

                if (!_IsSHILInited())
                    return FALSE;
            }

            if (phiml)
                *phiml = g_rgshil[SHIL_LARGE].himl;

            if (phimlSmall)
                *phimlSmall = g_rgshil[SHIL_SMALL].himl;

            return TRUE;
        }

        SHMapPIDLToSystemImageListIndex(psf, pidlLast, &psfi->iIcon) {
            SHGetIconFromPIDL() {
                Shell_GetCachedImageIndex() {
                    int iImageIndex = LookupIconIndex(pszIconPath, iIconIndex, uIconFlags);
                    if (iImageIndex == -1)
                    {
                        iImageIndex = SHAddIconsToCache(NULL, pszIconPath, iIconIndex, uIconFlags);
                    }
                }
            }
        }

        if (uFlags & SHGFI_SMALLICON)
        {
            himl = himlSmall;
            cx = GetSystemMetrics(SM_CXSMICON);
            cy = GetSystemMetrics(SM_CYSMICON);
        }
        else
        {
            himl = himlLarge;
            cx = GetSystemMetrics(SM_CXICON);
            cy = GetSystemMetrics(SM_CYICON);
        }

        psfi->hIcon = ImageList_GetIcon(himl, psfi->iIcon, flags);

        // if the caller does not want a "shell size" icon
        // convert the icon to the "system" icon size.
        if (psfi->hIcon && !(uFlags & SHGFI_SHELLICONSIZE))
            psfi->hIcon = (HICON)CopyImage(psfi->hIcon, IMAGE_ICON, cx, cy, LR_COPYRETURNORG | LR_COPYDELETEORG);
    }
}
```

- [FileIconInit](https://learn.microsoft.com/en-us/windows/win32/shell/fileiconinit)

  > If you are using system image lists in your own process, you must call **FileIconInit** at the following times:
  > 
  > - On launch.
  > - In response to a [**WM\_SETTINGCHANGE**](https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-settingchange) message when the [**SPI\_SETNONCLIENTMETRICS**](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfoa) flag is set.
  > 
  > `FileIconInit` is not included in a header file. You must call it directly from `Shell32.dll`, using ordinal 660.

- `SHGFI_USEFILEATTRIBUTES`
  - Even `SHGFI_USEFILEATTRIBUTES` is set, the file will still be read if its icon is not in cache. Use the extension as path (like `.exe`) can avoid this.
  - If flags has `FILE_ATTRIBUTE_DIRECTORY`, and the path is `""`, `SHGetFileInfo` will return the volume icon, not the folder icon. To get the folder icon, one can instead use `C:\Windows` as the path.

- Because system image lists are created on a *per-process* basis, you should treat them as read-only objects. Writing to a system image list may overwrite or delete one of the system images, making it unavailable or incorrect for the remainder of the process.

<details>

```cpp
// Windows XP SP1

//
//  This function returns shell info about a given pathname.
//  a app can get the following:
//
//      Icon (large or small)
//      Display Name
//      Name of File Type
//
//  this function replaces SHGetFileIcon

#define BUGGY_SHELL16_CBFILEINFO    (sizeof(SHFILEINFO) - 4)

STDAPI_(DWORD_PTR) SHGetFileInfo(LPCTSTR pszPath, DWORD dwFileAttributes, SHFILEINFO *psfi, UINT cbFileInfo, UINT uFlags)
{
    LPITEMIDLIST pidlFull;
    DWORD_PTR res = 1;
    TCHAR szPath[MAX_PATH];

    // this was never enforced in the past
    // TODDB: The 16 to 32 bit thunking layer passes in the wrong value for cbFileInfo.
    // The size passed in looks to be the size of the 16 bit version of the structure
    // rather than the size of the 32 bit version, as such it is 4 bytes shorter.
    // TJGREEN: Special-case that size to keep the assertion from firing and party on.
    // 
    ASSERT(!psfi || cbFileInfo == sizeof(*psfi) || cbFileInfo == BUGGY_SHELL16_CBFILEINFO);

    // You can't use both SHGFI_ATTR_SPECIFIED and SHGFI_ICON.
    ASSERT(uFlags & SHGFI_ATTR_SPECIFIED ? !(uFlags & SHGFI_ICON) : TRUE);

    if (pszPath == NULL)
        return 0;

    if (uFlags == SHGFI_EXETYPE)
        return GetExeType(pszPath);     // funky way to get EXE type

    if (psfi == NULL)
        return 0;

    psfi->hIcon = 0;

    // Zip Pro 6.0 relies on the fact that if you don't ask for the icon,
    // the iIcon field doesn't change.
    //
    // psfi->iIcon = 0;

    psfi->szDisplayName[0] = 0;
    psfi->szTypeName[0] = 0;

    //  do some simmple check on the input path.
    if (!(uFlags & SHGFI_PIDL))
    {
        // If the caller wants us to give them the file attributes, we can't trust
        // the attributes they gave us in the following two situations.
        if (uFlags & SHGFI_ATTRIBUTES)
        {
            if ((dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) &&
                (dwFileAttributes & (FILE_ATTRIBUTE_SYSTEM | FILE_ATTRIBUTE_READONLY)))
            {
                DebugMsg(TF_FSTREE, TEXT("SHGetFileInfo cant use caller supplied file attribs for a sys/ro directory (possible junction)"));
                uFlags &= ~SHGFI_USEFILEATTRIBUTES;
            }
            else if (PathIsRoot(pszPath))
            {
                DebugMsg(TF_FSTREE, TEXT("SHGetFileInfo cant use caller supplied file attribs for a roots"));
                uFlags &= ~SHGFI_USEFILEATTRIBUTES;
            }
        }

        if (PathIsRelative(pszPath))
        {
            if (uFlags & SHGFI_USEFILEATTRIBUTES)
            {
                // get a shorter path than the current directory to support
                // long pszPath names (that might get truncated in the 
                // long current dir case)

                GetWindowsDirectory(szPath, ARRAYSIZE(szPath));
            }
            else
            {
                GetCurrentDirectory(ARRAYSIZE(szPath), szPath);
            }
            PathCombine(szPath, szPath, pszPath);
            pszPath = szPath;
        }
    }

    if (uFlags & SHGFI_PIDL)
        pidlFull = (LPITEMIDLIST)pszPath;
    else if (uFlags & SHGFI_USEFILEATTRIBUTES)
    {
        WIN32_FIND_DATA fd = {0};
        fd.dwFileAttributes = dwFileAttributes;
        SHSimpleIDListFromFindData(pszPath, &fd, &pidlFull);
    }
    else
        pidlFull = ILCreateFromPath(pszPath);

    if (pidlFull)
    {
        if (uFlags & (
            SHGFI_DISPLAYNAME   |
            SHGFI_ATTRIBUTES    |
            SHGFI_SYSICONINDEX  |
            SHGFI_ICONLOCATION  |
            SHGFI_ICON          | 
            SHGFI_TYPENAME))
        {
            res = _GetFileInfoSections(pidlFull, psfi, uFlags);
        }

        if (!(uFlags & SHGFI_PIDL))
            ILFree(pidlFull);
    }
    else
        res = 0;

    return res;
}

// Return 1 on success and 0 on failure.
DWORD_PTR _GetFileInfoSections(LPITEMIDLIST pidl, SHFILEINFO *psfi, UINT uFlags)
{
    DWORD_PTR dwResult = 1;
    IShellFolder *psf;
    LPCITEMIDLIST pidlLast;
    HRESULT hr = SHBindToIDListParent(pidl, IID_PPV_ARG(IShellFolder, &psf), &pidlLast);
    if (SUCCEEDED(hr))
    {
        // get attributes for file
        if (uFlags & SHGFI_ATTRIBUTES)
        {
            // [New in IE 4.0] If SHGFI_ATTR_SPECIFIED is set, we use psfi->dwAttributes as is

            if (!(uFlags & SHGFI_ATTR_SPECIFIED))
                psfi->dwAttributes = 0xFFFFFFFF;      // get all of them

            if (FAILED(psf->GetAttributesOf(1, &pidlLast, &psfi->dwAttributes)))
                psfi->dwAttributes = 0;
        }

        //
        // get icon location, place the icon path into szDisplayName
        //
        if (uFlags & SHGFI_ICONLOCATION)
        {
            IExtractIcon *pxi;

            if (SUCCEEDED(psf->GetUIObjectOf(NULL, 1, &pidlLast, IID_PPV_ARG_NULL(IExtractIcon, &pxi))))
            {
                UINT wFlags;
                pxi->GetIconLocation(0, psfi->szDisplayName, ARRAYSIZE(psfi->szDisplayName),
                    &psfi->iIcon, &wFlags);

                pxi->Release();

                // the returned location is not a filename we cant return it.
                // just give then nothing.
                if (wFlags & GIL_NOTFILENAME)
                {
                    // special case one of our shell32.dll icons......

                    if (psfi->szDisplayName[0] != TEXT('*'))
                        psfi->iIcon = 0;

                    psfi->szDisplayName[0] = 0;
                }
            }
        }

        HIMAGELIST himlLarge, himlSmall;

        // get the icon for the file.
        if ((uFlags & SHGFI_SYSICONINDEX) || (uFlags & SHGFI_ICON))
        {
            Shell_GetImageLists(&himlLarge, &himlSmall);

            if (uFlags & SHGFI_SYSICONINDEX)
                dwResult = (DWORD_PTR)((uFlags & SHGFI_SMALLICON) ? himlSmall : himlLarge);

            if (uFlags & SHGFI_OPENICON)
                SHMapPIDLToSystemImageListIndex(psf, pidlLast, &psfi->iIcon);
            else
                psfi->iIcon = SHMapPIDLToSystemImageListIndex(psf, pidlLast, NULL);
        }

        if (uFlags & SHGFI_ICON)
        {
            HIMAGELIST himl;
            UINT flags = 0;
            int cx, cy;

            if (uFlags & SHGFI_SMALLICON)
            {
                himl = himlSmall;
                cx = GetSystemMetrics(SM_CXSMICON);
                cy = GetSystemMetrics(SM_CYSMICON);
            }
            else
            {
                himl = himlLarge;
                cx = GetSystemMetrics(SM_CXICON);
                cy = GetSystemMetrics(SM_CYICON);
            }

            if (!(uFlags & SHGFI_ATTRIBUTES))
            {
                psfi->dwAttributes = SFGAO_LINK;    // get link only
                psf->GetAttributesOf(1, &pidlLast, &psfi->dwAttributes);
            }

            //
            //  check for a overlay image thing (link overlay)
            //
            if ((psfi->dwAttributes & SFGAO_LINK) || (uFlags & SHGFI_LINKOVERLAY))
            {
                IShellIconOverlayManager *psiom;
                HRESULT hrT = GetIconOverlayManager(&psiom);
                if (SUCCEEDED(hrT))
                {
                    int iOverlayIndex = 0;
                    hrT = psiom->GetReservedOverlayInfo(NULL, -1, &iOverlayIndex, SIOM_OVERLAYINDEX, SIOM_RESERVED_LINK);
                    if (SUCCEEDED(hrT))
                        flags |= INDEXTOOVERLAYMASK(iOverlayIndex);
                }
            }
            if ((uFlags & SHGFI_ADDOVERLAYS) || (uFlags & SHGFI_OVERLAYINDEX))
            {
                IShellIconOverlay * pio;
                if (SUCCEEDED(psf->QueryInterface(IID_PPV_ARG(IShellIconOverlay, &pio))))
                {
                    int iOverlayIndex = 0;
                    if (SUCCEEDED(pio->GetOverlayIndex(pidlLast, &iOverlayIndex)))
                    {
                        if (uFlags & SHGFI_ADDOVERLAYS)
                        {
                            flags |= INDEXTOOVERLAYMASK(iOverlayIndex);
                        }
                        if (uFlags & SHGFI_OVERLAYINDEX)
                        {
                            // use the upper 16 bits for the overlayindex
                            psfi->iIcon |= iOverlayIndex << 24;
                        }
                    }
                    pio->Release();
                }
            }
            
            
            //  check for selected state
            if (uFlags & SHGFI_SELECTED)
                flags |= ILD_BLEND50;

            psfi->hIcon = ImageList_GetIcon(himl, psfi->iIcon, flags);

            // if the caller does not want a "shell size" icon
            // convert the icon to the "system" icon size.
            if (psfi->hIcon && !(uFlags & SHGFI_SHELLICONSIZE))
                psfi->hIcon = (HICON)CopyImage(psfi->hIcon, IMAGE_ICON, cx, cy, LR_COPYRETURNORG | LR_COPYDELETEORG);
        }

        // get display name for the path
        if (uFlags & SHGFI_DISPLAYNAME)
        {
            DisplayNameOf(psf, pidlLast, SHGDN_NORMAL, psfi->szDisplayName, ARRAYSIZE(psfi->szDisplayName));
        }

        if (uFlags & SHGFI_TYPENAME)
        {
            IShellFolder2 *psf2;
            if (SUCCEEDED(psf->QueryInterface(IID_PPV_ARG(IShellFolder2, &psf2))))
            {
                VARIANT var;
                VariantInit(&var);
                if (SUCCEEDED(psf2->GetDetailsEx(pidlLast, &SCID_TYPE, &var)))
                {
                    VariantToStr(&var, psfi->szTypeName, ARRAYSIZE(psfi->szTypeName));
                    VariantClear(&var);
                }
                psf2->Release();
            }
        }

        psf->Release();
    }
    else
        dwResult = 0;

    return dwResult;
}
```
</details>

## [`IShellItemImageFactory`](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-ishellitemimagefactory) (Vista)
Caches:
1. Memory (incluing per-class icons)
2. Disk caches

The documentation says `SIIGBF_INCACHEONLY` and `SIIGBF_MEMORYONLY` "only returns an already-cached icon and can fall back to a per-class icon if an item has a per-instance icon that has not been cached". But actually using them may cause `GetImage` to continuously return `0x8000000A` ("The data necessary to complete this operation is not yet available.") for a long time for uncached per-class icons. Even worse, the cache may be small, which results in thrashing. And file types with icon handlers cannot get per-class icons.

## Caches
### `IconCache.db`
[Rebuild Corrupt Icon Cache, Clear Thumbnail cache in Windows 11/10](https://www.thewindowsclub.com/rebuild-icon-clear-thumbnail-cache-windows-10)

[Structure and application of IconCache.db files for digital forensics - ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1742287614000607)

[The windows IconCache.db: A resource for forensic artifacts from USB connectable devices - ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1742287613000078)

### MuiCache
Tools:
- [MUICacheView - Edit/delete MUICache items](http://www.nirsoft.net/utils/muicache_view.html)

## Performance
API | Arguments | Time
--- | --- | ---
`SHGetFileInfo` | `Path.GetExtension(path)`<br />`SHGFI_USEFILEATTRIBUTES \| SHGFI_SMALLICON` | 0~3 ms
`SHGetFileInfo` | `SHGFI_USEFILEATTRIBUTES \| SHGFI_SMALLICON` | 0~3 ms
`SHGetFileInfo` | `SHGFI_USEFILEATTRIBUTES \| SHGFI_SMALLICON`<br />`Directory.Exists(path) ? FILE_ATTRIBUTE_DIRECTORY : FILE_ATTRIBUTE_NORMAL` | 0~5 ms
`IShellItemImageFactory` | `SIIGBF_MEMORYONLY` | 1~5 ms
`IShellItemImageFactory` | `SIIGBF_INCACHEONLY` | 1~10 ms
`IShellItemImageFactory` | `SIIGBF_ICONONLY` | 1~20 ms

Despite the low average time cost of `SIIGBF_MEMORYONLY` is low, it has some outliers up to 30ms and [some other problems](#ishellitemimagefactory-vista). In contrast, normal `SHGetFileInfo` has outliers up to 15ms (it will extract the icon if it is not in cache).

To make the UI fluent, one can first call `SHGetFileInfo` with the extension to get the per-class icon (which is fast and has no outliers) and display it, and then call `IShellItemImageFactory` (or `SHGetFileInfo` if it is enough) to get the per-instance icon and display it instead.

[c++ - SHGetFileInfo performance issues - Stack Overflow](https://stackoverflow.com/questions/54292062/shgetfileinfo-performance-issues)

[\[Feature\] Read icons from system cache - Issue #149 - Hofknecht/SystemTrayMenu](https://github.com/Hofknecht/SystemTrayMenu/issues/149)