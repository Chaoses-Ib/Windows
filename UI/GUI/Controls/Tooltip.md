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
> The window that contains the tool must relay the mouse messages to the tooltip control by sending `TTM_RELAYEVENT` messages to the control. The `lParam` of this message must contain the address of a `MSG` structure that specifies the message to be relayed to the tooltip control.
>
> You can specify `TTF_SUBCLASS` flag in the `uFlags` member of the `TOOLINFO` structure. This flag tells the tooltip control to subclass the window that contains the tool so it can intercept the mouse messages without the cooperation of the window. This method is easier to use since it doesn't require more coding than specifying `TTF_SUBCLASS` flag and the tooltip control handles all the message interception itself.

[Tool Tip Class - CodeProject](https://www.codeproject.com/Articles/20729/Tool-Tip-Class)

[Custom-Drawn Win32 Tooltips | Steven Engelhardt](https://www.stevenengelhardt.com/2007/08/29/custom-drawn-win32-tooltips/)

[Adding real Win32 tooltips for windowless controls - VB 6 sample code - developer Fusion](https://www.developerfusion.com/code/3890/adding-real-win32-tooltips-for-windowless-controls/)
