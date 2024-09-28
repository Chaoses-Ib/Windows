# File Explorer
- [Dijji/FileMeta: Enable Explorer in Vista, Windows 7 and later to see, edit and search on tags and other metadata for any file type](https://github.com/Dijji/FileMeta)
- [Aeindus/IFilterShellView: Another windows shell extension that will help you filter and select with ease folder and file items in windows explorer](https://github.com/Aeindus/IFilterShellView)

  跟 Listary 类似，可以搜索资源管理器列表，不过已经停更三年了。

## Open folder and select items
- [`SHOpenFolderAndSelectItems()`](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shopenfolderandselectitems)

  C#: [How to use SHOpenFolderAndSelectItems - Stack Overflow](https://stackoverflow.com/questions/3018002/c-how-to-use-shopenfolderandselectitems)

  e.g. 飞书

- `explorer.exe /select,"C:\Folder\subfolder\file.txt"`
  - Even when the folder is already opened in an Explorer window, this command will still open a new window to select the file.
  - Much slower than `SHOpenFolderAndSelectItems()`.

[c# - How to open Explorer with a specific file selected? - Stack Overflow](https://stackoverflow.com/questions/13680415/how-to-open-explorer-with-a-specific-file-selected)