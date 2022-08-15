# Package Formats
1. Archives
2. [MSI (Windows Installer)](#msi-windows-installer)
3. [ClickOnce](#clickonce)
4. [App-V](https://en.wikipedia.org/wiki/Microsoft_App-V)
5. [AppX](https://en.wikipedia.org/wiki/Universal_Windows_Platform_apps#APPX)
6. [MSIX](#msix)

## MSI (Windows Installer)
[Windows Installer](https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-portal)

## MSIX
[MSIX documentation](https://docs.microsoft.com/en-us/windows/msix/)

Books:
- [MSIX Packaging Fundamentals](https://www.advancedinstaller.com/msix-packaging-fundamentals.html)
- [MSIX Introduction: A comprehensive 24-chapter guide](https://www.advancedinstaller.com/msix-introduction.html)

### Restrictions
[Prepare to package a desktop application](https://docs.microsoft.com/en-us/windows/msix/desktop/desktop-to-uwp-prepare)

[MSI vs MSIX: Practical Side-by-Side Comparison and Limitations](https://www.advancedinstaller.com/msix-limitations.html)

Shell:
- Shell extensions are not supported since your app's modules cannot be loaded in-process to processes that are not in your Windows app package.
- [Context menu in MSIX](https://www.advancedinstaller.com/msix-context-menu.html)

## ClickOnce
ClickOnce is a component of Microsoft .NET Framework 2.0 and later, and supports deploying applications made with Windows Forms or Windows Presentation Foundation.[^click-wiki]

- [Visual Studio](https://docs.microsoft.com/en-us/visualstudio/deployment/clickonce-security-and-deployment)
- [ClickOnce packager](https://github.com/mansellan/clickonce)

[^click-wiki]: [ClickOnce - Wikipedia](https://en.wikipedia.org/wiki/ClickOnce)