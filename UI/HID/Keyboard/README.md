# Keyboard
[`KEYBOARD_INPUT_DATA`](https://learn.microsoft.com/en-us/windows/win32/api/ntddkbd/ns-ntddkbd-keyboard_input_data)

[Loading keyboard layout (KbdLayerDescriptor) in 32/64-bit environment - CodeProject](https://www.codeproject.com/Articles/439275/Loading-keyboard-layout-KbdLayerDescriptor-in-32-6)

## USB HID usage IDs
[USB: HID Usage Table - tmk/tmk\_keyboard Wiki](https://github.com/tmk/tmk_keyboard/wiki/USB:-HID-Usage-Table#note-7)

## Scan codes
[How to determine if a numpad is present and how to obtain the scan code for the numpad enter key? - Stack Overflow](https://stackoverflow.com/questions/51173472/how-to-determine-if-a-numpad-is-present-and-how-to-obtain-the-scan-code-for-the)
> At least since Windows NT system uses **PS/2 Scan Code Set 1** for all keyboard APIs. With some bugs that are specifically supported for backwards compatibility (for example NumLock and Pause scan codes are swapped. [They are special](https://en.wikipedia.org/wiki/Break_key#Modern_keyboards).).

> Under all Microsoft operating systems, all keyboards actually transmit Scan Code Set 2 values down the wire from the keyboard to the keyboard port. These values are translated to Scan Code Set 1 by the i8042 port chip. The rest of the operating system, and all applications that handle scan codes expect the values to be from Scan Code Set 1.

- [`MapVirtualKeyW()`](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mapvirtualkeyw)
  - Does not really work for extended keys.

    [\[Solved\] Sendinput and mapvirtualkeyex - CodeProject](https://www.codeproject.com/Questions/1273784/Sendinput-and-mapvirtualkeyex)

Used in [`KEYBOARD_INPUT_DATA`](https://learn.microsoft.com/en-us/windows/win32/api/ntddkbd/ns-ntddkbd-keyboard_input_data).

### PS/2 scan codes
[PS/2 Keyboard - OSDev Wiki](https://wiki.osdev.org/PS/2_Keyboard)

[USB HID to PS/2 Scan Code Translation Table](https://download.microsoft.com/download/1/6/1/161ba512-40e2-4cc9-843a-923143f3456c/translate.pdf)

[`HidP_TranslateUsagesToI8042ScanCodes()`](https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/hidpi/nf-hidpi-hidp_translateusagestoi8042scancodes):
```cpp
#include <iostream>
#include <Windows.h>
#include <hidsdi.h>
#include <hidpi.h>

#pragma comment(lib, "Hid.lib")

BOOLEAN insertCodes(
    IN PVOID  Context,
    IN PCHAR  NewScanCodes,
    IN ULONG  Length
) {
    auto h = *(uint8_t*)NewScanCodes;
    auto l = *((uint8_t*)NewScanCodes + 1);
    std::cout << (int)l << ' ' << (int)h << ' ' << Length << std::endl;
    return true;
}

int main()
{
    auto v = MapVirtualKeyW(VK_DOWN, MAPVK_VK_TO_VSC_EX);
    auto l = v & 0xFF;
    auto h = v >> 16;
    std::cout << l << ' ' << h << std::endl;
    // 80 0

    USAGE usageList[] = { 0x51 };
    HIDP_KEYBOARD_MODIFIER_STATE modifierState = {};
    HidP_TranslateUsagesToI8042ScanCodes(usageList, 1, HIDP_KEYBOARD_DIRECTION::HidP_Keyboard_Make, &modifierState, insertCodes, NULL);
    // 80 224
}
```

[PS/2 (I8042prt) Driver - Windows drivers | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/drivers/hid/ps-2--i8042prt--driver)