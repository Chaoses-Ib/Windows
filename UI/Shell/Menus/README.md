# Context Menus
[Shell context menu support](https://www.zabkat.com/2xExplorer/shellFAQ/bas_context.html)

[How to host an IContextMenu, part 1 -- Initial foray](https://devblogs.microsoft.com/oldnewthing/20040920-00/?p=37823)
- [How to host an IContextMenu, part 2 -- Displaying the context menu](https://devblogs.microsoft.com/oldnewthing/20040922-00/?p=37793)
- [How to host an IContextMenu, part 3 -- Invocation location](https://devblogs.microsoft.com/oldnewthing/20040923-00/?p=37773)
- [How to host an IContextMenu, part 4 -- Key context](https://devblogs.microsoft.com/oldnewthing/20040924-00/?p=37753)
- [How to host an IContextMenu, part 5 -- Handling menu messages](https://devblogs.microsoft.com/oldnewthing/20040927-00/?p=37733)
- [How to host an IContextMenu, part 6 -- Displaying menu help](https://devblogs.microsoft.com/oldnewthing/20040928-00/?p=37723)
- [How to host an IContextMenu, part 7 -- Invoking the default verb](https://devblogs.microsoft.com/oldnewthing/20040930-00/?p=37693)
- [How to host an IContextMenu, part 8 -- Optimizing for the default command](https://devblogs.microsoft.com/oldnewthing/20041001-00/?p=37683)
- [How to host an IContextMenu, part 9 -- Adding custom commands](https://devblogs.microsoft.com/oldnewthing/20041004-00/?p=37673)
- [How to host an IContextMenu, part 10 -- Composite extensions -- groundwork](https://devblogs.microsoft.com/oldnewthing/20041006-00/?p=37643)
- [How to host an IContextMenu, part 11 -- Composite extensions -- composition](https://devblogs.microsoft.com/oldnewthing/20041007-00/?p=37633)

[Psychic debugging: Why your IContextMenu::InvokeCommand doesn't get called even though you returned success from IContextMenu::QueryContextMenu - The Old New Thing](https://devblogs.microsoft.com/oldnewthing/20130201-00/?p=5383)

[windows - C# - How to trigger the App in open with context menu properly - Stack Overflow](https://stackoverflow.com/questions/65139754/c-sharp-how-to-trigger-the-app-in-open-with-context-menu-properly)

## QueryContextMenu
- Although `QueryContextMenu` has an argument `indexMenu` for specifying the position to insert the menu items, it could make the order a mess in real life, possibly due to some extension developers handled it in a wrong way.

  A workaround is to insert other items after `QueryContextMenu` is done.

`COpenWithMenu`:
```cpp
// Windows XP SP1

//  Our context menu IDs are assigned like this
//
//  idCmdFirst = Open With Custom Program (either on main menu or on popup)
//  idCmdFirst+1 through idCmdFirst+_nItems = Open With program in OpenWithList

#define OWMENU_BROWSE       0
#define OWMENU_APPFIRST     1


HRESULT COpenWithMenu::QueryContextMenu(HMENU hmenu, UINT indexMenu, UINT idCmdFirst, UINT idCmdLast, UINT uFlags)
{
    MENUITEMINFO mii;
    LPTSTR pszExt;
    TCHAR szOpenWithMenu[80];
    
    _idCmdFirst = idCmdFirst;
    _uFlags = uFlags;
    
    if (SUCCEEDED(PathFromDataObject(_pdtobj, _szPath, ARRAYSIZE(_szPath))))
    {
        // No openwith context menu for executables.
        if (PathIsExe(_szPath))
            return S_OK;

        pszExt = PathFindExtension(_szPath);
        if (pszExt && *pszExt)
        {
            // Add Open/Edit/Default verb to extension app list
            if (SUCCEEDED(AddVerbItems(pszExt)))
            {
                // Do this only if AddVerbItems succeeded; otherwise,
                // we would create an empty MRU for a nonexisting class,
                // causing the class to spring into existence and cause
                // the "Open With" dialog to think we are overriding
                // rather than creating new.
                // get extension app list
                
                if (_owa.Create(4) && SUCCEEDED(_owa.FillArray(pszExt)))
                {
                    _nItems = _owa.GetPtrCount();
                    if (1 == _nItems)
                    {
                        // For known file type(there is at least one verb under its progid), 
                        // if there is only one item in its openwithlist, don't show open with sub menu
                        _nItems = 0;
                    }
                }
            }
        }
    }

    LoadString(g_hinst, (_nItems ? IDS_OPENWITH : IDS_OPENWITHNEW), szOpenWithMenu, ARRAYSIZE(szOpenWithMenu));

    if (_nItems)
    {
        //  we need to create a submenu
        //  with all of our goodies
        _hMenu = CreatePopupMenu();
        if (_hMenu)
        {
            _fMenuNeedsInit = TRUE;
            
            mii.cbSize = sizeof(MENUITEMINFO);
            mii.fMask = MIIM_ID|MIIM_TYPE|MIIM_DATA;
            mii.wID = idCmdFirst+OWMENU_APPFIRST;
            mii.fType = MFT_STRING;
            mii.dwTypeData = szOpenWithMenu;
            mii.dwItemData = 0;
        
            InsertMenuItem(_hMenu,0,TRUE,&mii);
        
            mii.fMask = MIIM_ID|MIIM_SUBMENU|MIIM_TYPE;
            mii.fType = MFT_STRING;
            mii.wID = idCmdFirst+OWMENU_BROWSE;
            mii.hSubMenu = _hMenu;
            mii.dwTypeData = szOpenWithMenu;
        
            InsertMenuItem(hmenu,indexMenu,TRUE,&mii);
        }
    }
    else
    {
        mii.cbSize = sizeof(MENUITEMINFO);
        mii.fMask = MIIM_ID|MIIM_TYPE|MIIM_DATA;
        mii.fType = MFT_STRING;
        mii.wID = idCmdFirst+OWMENU_BROWSE;
        mii.dwTypeData = szOpenWithMenu;
        mii.dwItemData = 0;
        
        InsertMenuItem(hmenu,indexMenu,TRUE,&mii);

    }
    return ResultFromShort(_nItems + 1);

}
```

## HandleMenuMsg
`COpenWithMenu`:
```cpp
// Windows XP SP1
HRESULT COpenWithMenu::HandleMenuMsg2(UINT uMsg, WPARAM wParam, LPARAM lParam,LRESULT *plResult)
{
    LRESULT lResult = 0;
    HRESULT hr = S_OK;

    switch (uMsg)
    {
    case WM_INITMENUPOPUP:
        InitMenuPopup(_hMenu) {
                TraceMsg(TF_OPENWITHMENU, "COpenWithMenu::InitMenuPopup");

                if (_fMenuNeedsInit)
                {
                    TCHAR szMenuText[80];
                    MENUITEMINFO mii;
                    // remove the place holder.
                    DeleteMenu(hmenu,0,MF_BYPOSITION);

                    // add app's in mru list to context menu
                    for (int i = 0; i < _owa.GetPtrCount(); i++)
                    {
                        mii.cbSize = sizeof(MENUITEMINFO);
                        mii.fMask = MIIM_ID|MIIM_TYPE|MIIM_DATA;
                        mii.wID = _idCmdFirst + OWMENU_APPFIRST + i;
                        mii.fType = MFT_OWNERDRAW;
                        mii.dwItemData = i;

                        InsertMenuItem(hmenu,GetMenuItemCount(hmenu),TRUE,&mii);
                    }

                    // add seperator
                    AppendMenu(hmenu,MF_SEPARATOR,0,NULL); 

                    // add "Choose Program..."
                    LoadString(g_hinst, IDS_OPENWITHBROWSE, szMenuText, ARRAYSIZE(szMenuText));
                    mii.cbSize = sizeof(MENUITEMINFO);
                    mii.fMask = MIIM_ID|MIIM_TYPE|MIIM_DATA;
                    mii.wID = _idCmdFirst + OWMENU_BROWSE;
                    mii.fType = MFT_STRING;
                    mii.dwTypeData = szMenuText;
                    mii.dwItemData = 0;

                    InsertMenuItem(hmenu,GetMenuItemCount(hmenu),TRUE,&mii);
                    _fMenuNeedsInit = FALSE;
                    return TRUE;
                }
                return FALSE;
        }
        break;

    case WM_DRAWITEM:
        DrawItem((DRAWITEMSTRUCT *)lParam);
        break;
        
    case WM_MEASUREITEM:
        lResult = MeasureItem((MEASUREITEMSTRUCT *)lParam);    
        break;

    case WM_MENUCHAR:
        hr = _MatchMenuItem((TCHAR)LOWORD(wParam), &lResult);
        break;

    default:
        hr = E_NOTIMPL;
        break;
    }

    if (plResult)
        *plResult = lResult;

    return hr;
}
```

Default folder menu:
```cpp
// Windows XP SP1
STDMETHODIMP CDefFolderMenu::HandleMenuMsg2(UINT uMsg, WPARAM wParam, 
                                           LPARAM lParam,LRESULT* plResult)
{
    UINT uMsgFld;
    WPARAM wParamFld;       // map the folder call back params to these
    LPARAM lParamFld;
    UINT idCmd;
    UINT id; //temp var

    switch (uMsg) {
    case WM_MEASUREITEM:
        idCmd = GET_WM_COMMAND_ID(((MEASUREITEMSTRUCT *)lParam)->itemID, 0);
        // cannot use InRange because _idVerbMax can be equal to _idDelayInvokeMax
        id = idCmd-_idCmdFirst;
        if ((_bInitMenuPopup || (_hdsaStatics && _idVerbMax <= id)) && id < _idDelayInvokeMax)        
        {
            _MeasureItem((MEASUREITEMSTRUCT *)lParam);
            return S_OK;
        }
        
        uMsgFld = DFM_WM_MEASUREITEM;
        wParamFld = GetFldFirst(this);
        lParamFld = lParam;
        break;

    case WM_DRAWITEM:
        idCmd = GET_WM_COMMAND_ID(((LPDRAWITEMSTRUCT)lParam)->itemID, 0);
        // cannot use InRange because _idVerbMax can be equal to _idDelayInvokeMax
        id = idCmd-_idCmdFirst;
        if ((_bInitMenuPopup || (_hdsaStatics && _idVerbMax <= id)) && id < _idDelayInvokeMax)
        {
            _DrawItem((LPDRAWITEMSTRUCT)lParam);
            return S_OK;
        }

        uMsgFld = DFM_WM_DRAWITEM;
        wParamFld = GetFldFirst(this);
        lParamFld = lParam;
        break;

    case WM_INITMENUPOPUP:
        idCmd = GetMenuItemID((HMENU)wParam, 0);
        if (_uFlags & CMF_FINDHACK)
        {
            HMENU hmenu = (HMENU)wParam;
            int cItems = GetMenuItemCount(hmenu);
            
            _bInitMenuPopup = TRUE;
            if (!_hdsaCustomInfo)
                _hdsaCustomInfo = DSA_Create(sizeof(SEARCHINFO), 1);

            if (_hdsaCustomInfo && cItems > 0)
            {
                // need to go bottom up because we may delete some items
                for (int i = cItems - 1; i >= 0; i--)
                {
                    MENUITEMINFO mii = {0};
                    TCHAR szMenuText[MAX_PATH];

                    mii.cbSize = sizeof(mii);
                    mii.fMask = MIIM_TYPE | MIIM_DATA | MIIM_ID;
                    mii.dwTypeData = szMenuText;
                    mii.cch = ARRAYSIZE(szMenuText);
                    
                    if (GetMenuItemInfo(hmenu, i, TRUE, &mii) && (MFT_STRING == mii.fType))
                    {
                        SEARCHINFO sinfo;
                        // static items already have correct dwItemData (pointer to SEARCHEXTDATA added in _AddStatic)
                        // we now have to change other find extension's dwItemData from having an index into the icon
                        // cache to pointer to SEARCHEXTDATA
                        // cannot use InRange because _idVerbMax can be equal to _idDelayInvokeMax
                        id = mii.wID - _idCmdFirst;
                        if (!(_hdsaStatics && _idVerbMax <= id && id < _idDelayInvokeMax))
                        {
                            UINT iIcon = (UINT) mii.dwItemData;
                            SEARCHEXTDATA *psed = (SEARCHEXTDATA *)LocalAlloc(LPTR, sizeof(*psed));
                            if (psed)
                            {
                                psed->iIcon = iIcon;
                                SHTCharToUnicode(szMenuText, psed->wszMenuText, ARRAYSIZE(psed->wszMenuText));
                            }
                            mii.fMask = MIIM_DATA | MIIM_TYPE;
                            mii.fType = MFT_OWNERDRAW;
                            mii.dwItemData = (DWORD_PTR)psed;

                            sinfo.psed = psed;
                            sinfo.idCmd = mii.wID;
                            if (DSA_AppendItem(_hdsaCustomInfo, &sinfo) == -1)
                            {
                                DeleteMenu(hmenu, i, MF_BYPOSITION);
                                if (psed)
                                    LocalFree(psed);
                            }
                            else
                                SetMenuItemInfo(hmenu, i, TRUE, &mii);
                        }
                    }
                }
            }
            else if (!_hdsaCustomInfo)
            {
                // we could not allocate space for _hdsaCustomInfo
                // delete all items because there will be no pointer hanging off dwItemData
                // so start | search will fault
                for (int i = 0; i < cItems; i++)
                    DeleteMenu(hmenu, i, MF_BYPOSITION);
            }
        }
        
        uMsgFld = DFM_WM_INITMENUPOPUP;
        wParamFld = wParam;
        lParamFld = GetFldFirst(this);
        break;

    case WM_MENUSELECT:
        idCmd = (UINT) LOWORD(wParam);
        // cannot use InRange because _idVerbMax can be equal to _idDelayInvokeMax
        id = idCmd-_idCmdFirst;
        if (_punkSite && (_bInitMenuPopup || (_hdsaStatics && _idVerbMax <= id)) && id < _idDelayInvokeMax)
        {
            IShellBrowser *psb;
            if (SUCCEEDED(IUnknown_QueryService(_punkSite, SID_STopLevelBrowser, IID_PPV_ARG(IShellBrowser, &psb))))
            {
                MENUITEMINFO mii;

                mii.cbSize = sizeof(mii);
                mii.fMask = MIIM_DATA;
                mii.cch = 0; //just in case
                if (GetMenuItemInfo(_hmenu, idCmd, FALSE, &mii))
                {
                    SEARCHEXTDATA *psed = (SEARCHEXTDATA *)mii.dwItemData;
                    psb->SetStatusTextSB(psed->wszHelpText);
                }
                psb->Release();
            }
        }
        return S_OK;
        
      
    case WM_MENUCHAR:
        if ((_uFlags & CMF_FINDHACK) && _hdsaCustomInfo)
        {
            int cItems = DSA_GetItemCount(_hdsaCustomInfo);
            
            for (int i = 0; i < cItems; i++)
            {
                SEARCHINFO* psinfo = (SEARCHINFO*)DSA_GetItemPtr(_hdsaCustomInfo, i);
                ASSERT(psinfo);
                SEARCHEXTDATA* psed = psinfo->psed;
                
                if (psed)
                {
                    TCHAR szMenu[MAX_PATH];
                    SHUnicodeToTChar(psed->wszMenuText, szMenu, ARRAYSIZE(szMenu));
                
                    if (_MenuCharMatch(szMenu, (TCHAR)LOWORD(wParam), FALSE))
                    {
                        if (plResult) 
                            *plResult = MAKELONG(GetMenuPosFromID((HMENU)lParam, psinfo->idCmd), MNC_EXECUTE);
                        return S_OK;
                    }                            
                }
            }
            if (plResult) 
                *plResult = MAKELONG(0, MNC_IGNORE);
                
            return S_FALSE;
        }
        else
        {
            // TODO: this should probably get the idCmd of the MFS_HILITE item so we forward to the correct hdxa...
            idCmd = GetMenuItemID((HMENU)lParam, 0);
        }
        break;
        
    default:
        return E_FAIL;
    }

    // bias this down to the extension range (comes right after the folder range)

    idCmd -= _idCmdFirst + _idFolderMax;

    // Only forward along on IContextMenu3 as some shell extensions say they support
    // IContextMenu2, but fail and bring down the shell...
    IContextMenu3 *pcmItem;
    if (SUCCEEDED(HDXA_FindByCommand(_hdxa, idCmd, IID_PPV_ARG(IContextMenu3, &pcmItem))))
    {
        HRESULT hr = pcmItem->HandleMenuMsg2(uMsg, wParam, lParam, plResult);
        pcmItem->Release();
        return hr;
    }

    // redirect to the folder callback
    if (_pcmcb)
        return _pcmcb->CallBack(_psf, _hwnd, _pdtobj, uMsgFld, wParamFld, lParamFld);

    return E_FAIL;
}
```

## InvokeCommand
- For a dynamic submenu, `WM_INITMENUPOPUP` must be sent before invoking its verb with index.

`COpenWithMenu`:
```cpp
// Windows XP SP1
HRESULT COpenWithMenu::InvokeCommand(LPCMINVOKECOMMANDINFO pici)
{
    HRESULT hr = E_OUTOFMEMORY;
    CMINVOKECOMMANDINFOEX ici;
    void * pvFree;

    //  maybe these two routines should be collapsed into one?
    if ((IS_INTRESOURCE(pici->lpVerb) || 0 == lstrcmpiA(pici->lpVerb, "openas"))
    && SUCCEEDED(ICI2ICIX(pici, &ici, &pvFree)))
    {
        BOOL fOpenAs = TRUE;
        if (pici->lpVerb && IS_INTRESOURCE(pici->lpVerb))
        {
            int i = LOWORD(pici->lpVerb) - OWMENU_APPFIRST;
            if (i < _owa.GetPtrCount())
            {
                hr = _owa.GetPtr(i)->Handler()->Invoke(&ici, _szPath);
                fOpenAs = FALSE;
            }
        }

        if (fOpenAs)
        {
            SHELLEXECUTEINFO ei = {0};
            hr = ICIX2SEI(&ici, &ei);
            if (SUCCEEDED(hr))
            {
                // use the "Unknown" key so we get the openwith prompt
                ei.lpFile = _szPath;
                //  dont do the zone check before the user picks the app.
                //  wait until they actually try to invoke the file.
                ei.fMask |= SEE_MASK_NOZONECHECKS;
                RegOpenKeyEx(HKEY_CLASSES_ROOT, TEXT("Unknown"), 0, MAXIMUM_ALLOWED, &ei.hkeyClass);
                if (!(_uFlags & CMF_DEFAULTONLY))
                {
                    // defview sets CFM_DEFAULTONLY when the user is double-clicking. We check it
                    // here since we want do NOT want to query the class store if the user explicitly
                    // right-clicked on the menu and choo   se openwith.

                    // pop up open with dialog without querying class store
                    ei.fMask |= SEE_MASK_NOQUERYCLASSSTORE;
                }

                if (ei.hkeyClass)
                {
                    ei.fMask |= SEE_MASK_CLASSKEY;

                    if (ShellExecuteEx(&ei)) 
                    {
                        hr = S_OK;
                        if (UEMIsLoaded())
                        {
                            // note that we already got a UIBL_DOTASSOC (from
                            // OpenAs_RunDLL or whatever it is that 'Unknown'
                            // runs).  so the Uassist analysis app will have to
                            // subtract it off
                            UEMFireEvent(&UEMIID_SHELL, UEME_INSTRBROWSER, UEMF_INSTRUMENT, UIBW_RUNASSOC, UIBL_DOTNOASSOC);
                        }
                    }
                    else
                    {
                        hr = HRESULT_FROM_WIN32(GetLastError());
                    }
                    RegCloseKey(ei.hkeyClass);
                 }
                 else
                    hr = E_FAIL;
             }
        }

        LocalFree(pvFree);  // accepts NULL
    }        

    return hr;
}
```

## .NET
- [Files/src/Files.App/Utils/Shell/ContextMenu.cs](https://github.com/files-community/Files/blob/272406a56dfa7eb42ba431bc0baab72e48729e6f/src/Files.App/Utils/Shell/ContextMenu.cs)
- ~~http://www.codeproject.com/useritems/FileBrowser.asp~~
  - [Explorer Shell Context Menu - CodeProject](https://www.codeproject.com/Articles/22012/Explorer-Shell-Context-Menu)
    - [SystemTrayMenu/UserInterface/ShellContextMenu.cs](https://github.com/Hofknecht/SystemTrayMenu/blob/80158ce9479c39b75f79a2072a0b2b39bfb058f3/UserInterface/ShellContextMenu.cs)
    - [EverythingToolbar/EverythingToolbar/Helpers/ShellContextMenu.cs](https://github.com/srwi/EverythingToolbar/blob/7886d1897d86c1f35cb54810d4afb55602724ce7/EverythingToolbar/Helpers/ShellContextMenu.cs)
    - [dnGrep/dnGREP.Common.UI/ShellContextMenu.cs](https://github.com/dnGrep/dnGrep/blob/a3ce2a7b8e84d4d6c3ef162e52c32fe5f84d544d/dnGREP.Common.UI/ShellContextMenu.cs)
    - [Explorer/ExplorerWpf/ShellContextMenu.cs](https://github.com/xuri-ajiva/Explorer/blob/b13b4b866a450e7f66c277e93d0cd16ac01aa0ef/ExplorerWpf/ShellContextMenu.cs)
    - [Flow.Launcher/Plugins/Flow.Launcher.Plugin.Explorer/Helper/ShellContextMenu.cs](https://github.com/Flow-Launcher/Flow.Launcher/blob/ef84b2b597f01fa775fa3c0fa96448c90d4a890a/Plugins/Flow.Launcher.Plugin.Explorer/Helper/ShellContextMenu.cs)
- [gong-shell/Shell/ShellContextMenu.cs](https://github.com/grokys/gong-shell/blob/master/Shell/ShellContextMenu.cs) (dicontinued)
  - [BetterExplorer/ShellControls/ShellContextMenu/ShellContextMenu.cs](https://github.com/Gainedge/BetterExplorer/blob/28bd3264601b0e6609de294689032660c331af80/ShellControls/ShellContextMenu/ShellContextMenu.cs)
- [C# File Browser - CodeProject](https://www.codeproject.com/Articles/15059/C-File-Browser)
  - [cairoshell/Cairo Desktop/CairoDesktop.Common/ShellContextMenu.cs](https://github.com/5l1v3r1/cairoshell/blob/091de84ae854801034c12a89292253b205c4a3bc/Cairo%20Desktop/CairoDesktop.Common/ShellContextMenu.cs)
- [ExplorerEx/ExplorerEx/Shell32/Shell32Interop.cs](https://github.com/DearVa/ExplorerEx/blob/6366791b1062c8ff864cbe6f65be1694c9232d5e/ExplorerEx/Shell32/Shell32Interop.cs#L380C36-L380C36)
- [starshipxac.ShellLibrary/Source/starshipxac.Windows.Shell/Controls/ShellContextMenu.cs](https://github.com/rasmus-z/starshipxac.ShellLibrary/blob/af221b9e47dd4eaa3d99c0f95080e96e5d1658e7/Source/starshipxac.Windows.Shell/Controls/ShellContextMenu.cs)
- [Explorer/ExplorerWpf/ShellContextMenu.cs](https://github.com/xuri-ajiva/Explorer/blob/b13b4b866a450e7f66c277e93d0cd16ac01aa0ef/ExplorerWpf/ShellContextMenu.cs)
- [qttabbar/QTTabBar/ShellContextMenu.cs](https://github.com/Parantric/qttabbar/blob/3a8de3ab7fa8613a5d2d5050dedfab63d26b15f9/QTTabBar/ShellContextMenu.cs)
- [RX-Explorer/AuxiliaryTrustProcess/Class/ContextMenu.cs](https://github.com/gg-big-org/RX-Explorer/blob/9c1fb2520e99dc77cbe7bda6f26b45ef9fd8b148/AuxiliaryTrustProcess/Class/ContextMenu.cs)
- Shell MegaPack (dicontinued)

## Tools
- [ShellMenuView: Disable / enable context menu items of Explorer](https://www.nirsoft.net/utils/shell_menu_view.html)
- [moudey/Shell: Powerful context menu manager for Windows File Explorer](https://github.com/moudey/Shell)