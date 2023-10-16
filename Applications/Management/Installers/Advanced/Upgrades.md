# Upgrades
[Upgrades Page](https://www.advancedinstaller.com/user-guide/upgrades.html)
- Downgrade is disallowed by default.

## Order
The default order is "Uninstall old version first and then install new version". This means the old version will be entirely removed before install the new version. To keep setting files, see [How do I prevent a file or registry entry from being uninstalled or repaired?](https://www.advancedinstaller.com/user-guide/qa-keep-file.html):
- `UPGRADINGPRODUCTCODE` (`UPGRADINGPRODUCTCODE OR OLDPRODUCTS` if former versions are released without using these options)
- If a parent folder is configured to "Do not overwrite..."/"Always overwrite...", its children files cannot change the behavior.
- [installation - Advanced Installer -- Don't overwrite file when update but remove the file when uninstall - Stack Overflow](https://stackoverflow.com/questions/49064553/advanced-installer-don-t-overwrite-file-when-update-but-remove-the-file-when-u)

Another solution is to use custom actions:
1. Before `Preparing`, copy files to a temp folder
2. After `Remove Resources`, move them back (with `UPGRADINGPRODUCTCODE OR OLDPRODUCTS` condition)

Note that `Copy file/folder` can only copy the source folder itself (intead of its content) to destination.
- To backup and restore a folder:
  1. `[Dir]` -> `[TempFolder]`
  2. `[TempFolder]\DirName` -> `[Dir]\..`
- Or just backup and restore every files.

Remember to set execution time to "Immediately" to bypass rollback.