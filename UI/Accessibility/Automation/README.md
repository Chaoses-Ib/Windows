# UI Automation
[Wikipedia](https://en.wikipedia.org/wiki/Microsoft_UI_Automation)

Windows 组件对 UIA 的支持并不算很好：

> In the **Native Windows GUI** features are missing: Lots of controls do not implement the patterns that they should implement. For example a **SplitButton** in a native Toolbar should implement the `Invoke` pattern to click the button and the `ExpandCollapse` pattern to open the drop-down menu. But the `ExpandCollapse` pattern is missing which makes it difficult to use SplitButtons. If you obtain a Toolbar SplitButton by `IUIAutomation->ElementFromPoint()` and then ask for it's parent you will get a crippled element. And the **Pager** control cannot be automated at all.
>
> Also in **WPF applications** there are controls that are implemented buggy by Microsoft: For example if you have a **Calendar** control you see two buttons at the top to switch to the next/previous month. If you execute the `Invoke` pattern on these buttons you will get an `UIA_E_NOTSUPPORTED` error. But this is not a bug on the client side of the framework, because for other buttons the `Invoke` pattern works correctly. This is a bug in the WPF Automation server. And if you test `IUIAutomationTextRange` with a WPF RichTextBox, you will find that several commands are not implemented: `Select()` and `ScrollIntoView()` do simply nothing.
> 
> or **.NET Forms applications** Microsoft did not make much effort to support them. The .NET **Calendar** control cannot be automated at all. The entire control is not even recognized as Calendar. It has the ControlType "Pane" with no child elements in it. The same applies to the **DateTimePicker**. And for complex controls like **DataGrid** and **PropertyGrid** the only implemented pattern is `LegacyIAccessible` which is a poor support. These controls should implement at least the `Table` and the `Grid` and the `ScrollItem` pattern.[^net-sys]

[microsoft/EasyRepro: Automated UI testing API for Dynamics 365](https://github.com/microsoft/EasyRepro)

## C++
- [microsoft/Microsoft-UI-UIAutomation: Utility library for consuming Windows UIAutomation platform APIs](https://github.com/microsoft/Microsoft-UI-UIAutomation)

## .NET
`System.Windows.Automation` 的封装太旧了，性能很低，应该用 COM 调用 `IUIAutomationElement`[^net-sys]：
- [FlaUI: UI automation library for .Net](https://github.com/FlaUI/FlaUI)
- [FlaUI/UIAutomation-Interop: Interop wrappers for UIAutomationCore and UIAutomationClient](https://github.com/FlaUI/UIAutomation-Interop) ([NuGet](https://www.nuget.org/packages/Interop.UIAutomationClient))
- [White](https://github.com/TestStack/White) (deprecated)

## Tools
- [Inspect](https://learn.microsoft.com/en-us/windows/win32/winauto/inspect-objects)
- [FlaUInspect: Inspect tool to inspect UIs from an automation perspective](https://github.com/FlaUI/FlaUInspect)
- [Accessibility Insights](https://accessibilityinsights.io/)


[^net-sys]: [c# - System.Windows.Automation is extremely slow - Stack Overflow](https://stackoverflow.com/questions/41768046/system-windows-automation-is-extremely-slow)