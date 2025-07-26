# Tooltip
[Tooltip - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/tooltip-control-reference)

[How to Create a Tooltip for a Control - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/create-a-tooltip-for-a-control)
```cpp
// Description:
//   Creates a tooltip for an item in a dialog box. 
// Parameters:
//   idTool - identifier of an dialog box item.
//   nDlg - window handle of the dialog box.
//   pszText - string to use as the tooltip text.
// Returns:
//   The handle to the tooltip.
//
HWND CreateToolTip(int toolID, HWND hDlg, PTSTR pszText)
{
    if (!toolID || !hDlg || !pszText)
    {
        return FALSE;
    }
    // Get the window of the tool.
    HWND hwndTool = GetDlgItem(hDlg, toolID);
    
    // Create the tooltip. g_hInst is the global instance handle.
    HWND hwndTip = CreateWindowEx(NULL, TOOLTIPS_CLASS, NULL,
                              WS_POPUP |TTS_ALWAYSTIP | TTS_BALLOON,
                              CW_USEDEFAULT, CW_USEDEFAULT,
                              CW_USEDEFAULT, CW_USEDEFAULT,
                              hDlg, NULL, 
                              g_hInst, NULL);
    
   if (!hwndTool || !hwndTip)
   {
       return (HWND)NULL;
   }                              
                              
    // Associate the tooltip with the tool.
    TOOLINFO toolInfo = { 0 };
    toolInfo.cbSize = sizeof(toolInfo);
    toolInfo.hwnd = hDlg;
    toolInfo.uFlags = TTF_IDISHWND | TTF_SUBCLASS;
    toolInfo.uId = (UINT_PTR)hwndTool;
    toolInfo.lpszText = pszText;
    SendMessage(hwndTip, TTM_ADDTOOL, 0, (LPARAM)&toolInfo);

    return hwndTip;
}
```

[Iczelion's Win32 Assembly Tutorial 27: Tooltip Control](http://www.interq.or.jp/chubu/r6/masm32/tute/tute027.html)
> The window that contains the tool must relay the mouse messages to the tooltip control by sending [`TTM_RELAYEVENT`](https://learn.microsoft.com/en-us/windows/win32/controls/ttm-relayevent) messages to the control. The `lParam` of this message must contain the address of a `MSG` structure that specifies the message to be relayed to the tooltip control.
>
> You can specify `TTF_SUBCLASS` flag in the `uFlags` member of the `TOOLINFO` structure. This flag tells the tooltip control to subclass the window that contains the tool so it can intercept the mouse messages without the cooperation of the window. This method is easier to use since it doesn't require more coding than specifying `TTF_SUBCLASS` flag and the tooltip control handles all the message interception itself.

[Tool Tip Class - CodeProject](https://www.codeproject.com/Articles/20729/Tool-Tip-Class)

[Custom-Drawn Win32 Tooltips | Steven Engelhardt](https://www.stevenengelhardt.com/2007/08/29/custom-drawn-win32-tooltips/)

[Adding real Win32 tooltips for windowless controls - VB 6 sample code - developer Fusion](https://www.developerfusion.com/code/3890/adding-real-win32-tooltips-for-windowless-controls/)

WinForms: [winforms/src/System.Windows.Forms/System/Windows/Forms/ToolTip/ToolTip.cs](https://github.com/dotnet/winforms/blob/0f4e03e1e16e5fb1d93adfd47c653c8863f7a2f6/src/System.Windows.Forms/System/Windows/Forms/ToolTip/ToolTip.cs)

[Win32 tooltips - Issue #43 - compio-rs/winio](https://github.com/compio-rs/winio/issues/43)
- [feat: add tooltip by Berrysoft - Pull Request #47 - compio-rs/winio](https://github.com/compio-rs/winio/pull/47)

## Timeouts
A tooltip control actually has three time-out durations associated with it:
- The initial duration is the time that the mouse pointer must remain stationary within the bounding rectangle of a tool before the tooltip window is displayed.
- The reshow duration is the length of the delay before subsequent tooltip windows are displayed when the pointer moves from one tool to another.
- The pop-up duration is the time that the tooltip window remains displayed before it is hidden. That is, if the pointer remains stationary within the bounding rectangle after the tooltip window is displayed, the tooltip window is automatically hidden at the end of the pop-up duration.

By default:
> The autopop time will be ten times the initial time and the reshow time will be one fifth the initial time.
>
> The default delay times are based on the double-click time. For the default double-click time of 500 ms, the initial, autopop, and reshow delay times are 500ms, 5000ms, and 100ms respectively.

You can adjust all of the time-out durations by using the [`TTM_SETDELAYTIME`](https://learn.microsoft.com/en-us/windows/win32/controls/ttm-setdelaytime) message.
- However, the maximum accepted duration is 65.535 seconds.
- `SendMessage(hwnd, TTM_SETDELAYTIME, TTDT_AUTOPOP, 0xFFFF)`

## Multiline tooltips
[How to Implement Multiline Tooltips - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/implement-multiline-tooltips)

[`TTM_SETMAXTIPWIDTH` message (Commctrl.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/ttm-setmaxtipwidth)

- If the tooltip is longer than the screen, multiline tooltip will be showed even without `TTM_SETMAXTIPWIDTH`.
- `TTM_SETMAXTIPWIDTH` with -1 doesn't work, and using `i32::MAX` will allow the tooltip to be longer than the screen (and possbily truncated at the border of current screen).

  WinForms uses `GetSystemMetrics(SM_CXMAXTRACK)`. But it is the total width of all screens plus 20, and will be truncated on non-leftest screen...

  [c++ - How can I get the size of the monitor that my current window is on in WinUI 3 and Win32? - Stack Overflow](https://stackoverflow.com/questions/76123063/how-can-i-get-the-size-of-the-monitor-that-my-current-window-is-on-in-winui-3-an)
- `\n` and `\r` also works for normal tooltips

  > I've found that \n works for normal tooltips, but neither \n nor \r\n works for balloon tooltips. I am not using Unicode.

[feat(win32): multiline tooltip by Chaoses-Ib - Pull Request #60 - compio-rs/winio](https://github.com/compio-rs/winio/pull/60)

[c++ - How do I get a multi line tooltip in MFC - Stack Overflow](https://stackoverflow.com/questions/153134/how-do-i-get-a-multi-line-tooltip-in-mfc)

[c++ - Windows yellow tooltip multiline? - Stack Overflow](https://stackoverflow.com/questions/4345790/windows-yellow-tooltip-multiline)
