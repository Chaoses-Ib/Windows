# File Explorer
## Open folder and select items
- [`SHOpenFolderAndSelectItems()`](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shopenfolderandselectitems)

  C#: [How to use SHOpenFolderAndSelectItems - Stack Overflow](https://stackoverflow.com/questions/3018002/c-how-to-use-shopenfolderandselectitems)

  e.g. 飞书

- `explorer.exe /select,"C:\Folder\subfolder\file.txt"`
  - Even when the folder is already opened in an Explorer window, this command will still open a new window to select the file.
  - Much slower than `SHOpenFolderAndSelectItems()`.

[c# - How to open Explorer with a specific file selected? - Stack Overflow](https://stackoverflow.com/questions/13680415/how-to-open-explorer-with-a-specific-file-selected)