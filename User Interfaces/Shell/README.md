# [Shell](https://docs.microsoft.com/en-us/windows/win32/shell/shell-entry)
The Windows UI provides users with access to a wide variety of objects necessary for running applications and managing the operating system. The **Shell** organizes these objects into a hierarchical namespace and provides users and applications with a consistent and efficient way to access and manage objects.

The most numerous and familiar of these objects are the folders and files that reside on computer disk drives. However, there are a number of situations where storing data as a collection of file-system folders and files might be undesirable or even impossible. Some examples of this type of data include:
- A collection of items that is most effectively packaged in a single file, such as a database.
- A collection of items that is most effectively stored in different locations, such as the Recycle Bin.
- A collection of items stored on a remote computer that does not have a standard Windows file system. An example of such data is the information stored on a personal digital assistant (PDA) or digital camera.
- A collection of items that does not represent stored data. An example of such data is the printer links contained by the standard Printers folder.

## [Namespace](https://docs.microsoft.com/en-us/windows/win32/shell/namespace-intro)
The Shell **namespace** organizes the file system and other objects managed by the Shell into a single tree-structured hierarchy. Conceptually, it is a larger and more inclusive version of the file system.

Like the file system, the namespace includes two basic types of object: folders and files. Within a folder, each object has an **item ID** ([SHITEMID](https://docs.microsoft.com/en-us/windows/win32/api/shtypes/ns-shtypes-shitemid)), which is the functional equivalent of a file or folder name. The item ID is rarely used by itself. Normally, it is part of an **item ID list** ([ITEMIDLIST](https://docs.microsoft.com/en-us/windows/win32/api/shtypes/ns-shtypes-itemidlist)), which serves the same purpose as a file system path.

The ultimate root of the namespace hierarchy is the desktop. Immediately below the root are several virtual folders such as My Computer and the Recycle Bin.

[List of Namespace extensions](https://docs.rainmeter.net/tips/launching-windows-special-folders/)

### Extensions
- [Namespace extensions](https://docs.microsoft.com/en-us/windows/win32/shell/nse-works)
- [Known Folders](https://docs.microsoft.com/en-us/windows/win32/shell/known-folders)

## [Shell extension handlers](https://docs.microsoft.com/en-us/windows/win32/shell/handlers)
The capabilities of the Shell can be extended with registry entries and `.ini` files. While this approach to extending the Shell is simple, and adequate for many purposes, it is limited. A more powerful and flexible approach to extending the Shell is to implement **shell extension handlers**. These handlers can be implemented for a variety of actions that the Shell can perform.

Handlers associated with a paricular file type:
- [Shortcut menu handler](https://docs.microsoft.com/en-us/windows/win32/shell/context-menu-handlers) (Context menu handler)  
  Called before a file's shortcut menu is displayed. It enables you to add items to the shortcut menu on a file-by-file basis.
- [Data handler](https://docs.microsoft.com/en-us/windows/win32/shell/how-to-create-data-handlers)  
  Called when a drag-and-drop operation is performed on `dragShell` objects. It enables you to provide additional clipboard formats to the drop target.
- [Drop handler](https://docs.microsoft.com/en-us/windows/win32/shell/how-to-create-drop-handlers)  
  Called when a data object is dragged over or dropped on a file. It enables you to make a file into a drop target.
- [Icon handler](https://docs.microsoft.com/en-us/windows/win32/shell/how-to-create-icon-handlers)  
  Called before a file's icon is displayed. It enables you to replace the file's default icon with a custom icon on a file-by-file basis.
- [Property sheet handler](https://docs.microsoft.com/en-us/windows/win32/shell/propsheet-handlers)  
  Called before an object's Properties property sheet is displayed. It enables you to add or replace pages.
- [Thumbnail image handler](https://docs.microsoft.com/en-us/windows/desktop/api/Thumbcache/nn-thumbcache-ithumbnailprovider)  
  Provides an image to represent the item.
- [Infotip handler](https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/nn-shlobj_core-iqueryinfo)  
  Provides pop-up text when the user hovers the mouse pointer over the object.
- [Property handler](https://docs.microsoft.com/en-us/windows/win32/properties/building-property-handlers) (Metadata handler)  
  Provides read and write access to metadata (properties) stored in a file. This can be used to extend the Details view, infotips, the property page, and grouping features.
- [Preview handler](https://docs.microsoft.com/en-us/windows/win32/shell/preview-handlers)  
  Called when an item is selected to show a lightweight, rich, read-only preview of the file's contents in the view's reading pane. This is done without launching the file's associated application.
- [Filter handler](https://docs.microsoft.com/en-us/windows/win32/search/-search-3x-wds-extidx-overview)  
  Allows file properties and its contents to be indexed and searched by Indexing Service or Windows Search.[^explorer-wiki]
- [AutoPlay event handler](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/windows-media-center-sdk/aa468474(v=msdn.10))  
  Examines newly discovered removable media and devices and, based on content such as pictures, music or video files, launches an appropriate application to play or display the content.[^explorer-wiki]

Other handlers:
- [Column handler](https://docs.microsoft.com/en-us/windows/win32/lwef/column-handlers) (only Windows XP or earlier)  
  Called by Windows Explorer before it displays the Details view of a folder. It enables you to add custom columns to the Details view.
- [Copy hook handler](https://docs.microsoft.com/en-us/windows/win32/shell/how-to-create-copy-hook-handlers)  
  Called when a folder or printer object is about to be moved, copied, deleted, or renamed. It enables you to approve or veto the operation.
- [Drag-and-drop handler](https://docs.microsoft.com/en-us/windows/win32/shell/context-menu-handlers#creating-drag-and-drop-handlers)  
  Called when a file is dragged with the right mouse button. It enables you to modify the shortcut menu that is displayed.
- [Icon overlay handler](https://docs.microsoft.com/en-us/windows/win32/shell/how-to-implement-icon-overlay-handlers)  
  Called before a file's icon is displayed. It enables you to specify an overlay for the file's icon.
- [Search handler](https://docs.microsoft.com/en-us/windows/win32/lwef/search-handlers)  
  Called to launch a search engine. It enables you to implement a custom search engine accessible from the Start menu or Windows Explorer.
- [Disk Cleanup handler](https://docs.microsoft.com/en-us/windows/win32/lwef/disk-cleanup)  
  Add a new entry to the Disk Cleanup application and allows specifying additional disk locations or files to clean up.[^explorer-wiki]

Tools:
- [ShellExView - Shell Extension Manager For Windows](https://www.nirsoft.net/utils/shexview.html)

## File Explorer
File Explorer (Windows Explorer) is a file manager included with Windows 95 and later.[^explorer-wiki]

[^explorer-wiki]: [File Explorer - Wikipedia](https://en.wikipedia.org/wiki/File_Explorer)

### Extensions
- [Ribbon extension](https://docs.microsoft.com/en-us/windows/win32/shell/extending-the-ribbon)

## [Taskbar](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar)
### [Extensions](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar-extensions)
- [Icon overlay](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar-extensions#icon-overlays)
- [Progress bar](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar-extensions#progress-bars)
- [Jump list](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar-extensions#jump-lists)
- [Thumbnail](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar-extensions#thumbnails)
- [Thumbnail toolbar](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar-extensions#thumbnail-toolbars)
- [Deskband](https://docs.microsoft.com/en-us/windows/win32/shell/taskbar-extensions#deskbands)
- [Notification](https://docs.microsoft.com/en-us/windows/win32/shell/notification-area)

## Desktop
### Extensions
- [Gadgets](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/sidebar/-sidebar-entry)

## .NET
- [SharpShell: Makes it easy to create Windows Shell Extensions using the .NET Framework.](https://github.com/dwmkerr/sharpshell)
- [ManagedShell: A library for creating Windows shell replacements using .NET.](https://github.com/cairoshell/ManagedShell)
- [MMSF: Managed Mini Shell extension Framework](https://github.com/vbaderks/mmsf)
- [starshipxac.ShellLibrary: This library that can be used with .NET Framework such as Windows Shell API, IFileDialog and so on.](https://github.com/rasmus-z/starshipxac.ShellLibrary)
- [gong-shell: A .NET Windows Shell library.](https://github.com/grokys/gong-shell) (discontinued)
- [ShellBrowser .NET Components | JAM Software](https://www.jam-software.com/shellbrowser_net) (paid)
- [Shell MegaPack : Windows Explorer-Like File & Folder Browser Controls & Components For .Net, WPF & ActiveX](https://www.ssware.com/megapack.htm) (discontinued)
  - [Shell MegaPack.WPF - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=LogicNP.ShellMegaPackWPF)
  - [Thank you for installing Shell MegaPack.WPF](http://www.ssware.com/install_shellmegapackwpf.htm)
- [Cairo: A customizable, intuitive desktop environment for Windows.](https://github.com/cairoshell/cairoshell)