# Text Input
[Custom text input overview - Windows apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/apps/design/input/custom-text-input)

## Input method editors
[Keyboard identifiers and input method editors for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-language-pack-default-values)

[How to delete a keyboard layout in Windows 10 - Super User](https://superuser.com/questions/957552/how-to-delete-a-keyboard-layout-in-windows-10)
- `HKEY_USERS\.DEFAULT\Keyboard Layout\Preload`
- `HKEY_CURRENT_USER\Keyboard Layout\Preload`
- `HKEY_USERS\.DEFAULT\Control Panel\International\User Profile`
- `HKEY_USERS\.DEFAULT\Control Panel\International\User Profile System Backup`
- Deny `SYSTEM` permissons to prevent these from reappearing.

尽管可以删除指定输入法，但无法指定输入法的切换顺序。