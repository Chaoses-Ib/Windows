# Windows Search
[Windows Search - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/search/windows-search)

> Windows Search replaces Windows Desktop Search (WDS), which was available as an add-in for Windows XP and Windows Server 2003. WDS replaced the legacy Indexing Service from previous versions of Windows with enhancements to performance, usability, and extensibility. The new development platform supports requirements that produce a more secure and stable system. While the new querying platform is not compatible with Microsoft Windows Desktop Search (WDS) 2.x, filters and protocol handlers written for previous versions of WDS can be updated to work with Windows Search. Windows Search also supports a new property system. For information on filters, property handlers, and protocol handlers, see [Extending the Index](https://learn.microsoft.com/en-us/windows/win32/search/-search-3x-wds-extidx-overview).

Blogs:
- [Windows Search Platform](https://devblogs.microsoft.com/windows-search-platform/)

## [Filter handlers](https://docs.microsoft.com/en-us/windows/win32/search/-search-3x-wds-extidx-overview)
[Wikipedia](https://en.wikipedia.org/wiki/IFilter)
  
Allows file properties and its contents to be indexed and searched by Indexing Service or Windows Search.[^explorer-wiki]

> In Windows 7 and later, filters written in managed code are explicitly blocked. Filters MUST be written in native code due to potential CLR versioning issues with the process that multiple add-ins run in.

API:
- [`LoadIFilter()` (ntquery.h)](https://learn.microsoft.com/en-us/windows/win32/api/ntquery/nf-ntquery-loadifilter)
  - The path can include a full filename or only the file name extension; for example, ".ext".
  - [`IFILTER_INIT`](https://learn.microsoft.com/en-us/windows/win32/api/filter/ne-filter-ifilter_init)

  [c# - LoadIFilter() fails on all PDFs (but MS's filtdump.exe doesn't.) - Stack Overflow](https://stackoverflow.com/questions/7177953/loadifilter-fails-on-all-pdfs-but-mss-filtdump-exe-doesnt)
  > You may want to see [this blog post](http://zabkat.com/blog/adobe-ifilter-exposed.htm). In short, v10 of Adobe's PDF filter uses a whitelist of applications allowed to use the filter, including Microsoft's diagnostic tools like `filtdump.exe`, supposedly as a "security measure".

- [`IFilter::GetChunk()`](https://learn.microsoft.com/en-us/windows/win32/api/filter/nf-filter-ifilter-getchunk)
  - [`CHUNK_BREAKTYPE`](https://learn.microsoft.com/en-us/windows/win32/api/filter/ne-filter-chunk_breaktype)

- [IFilter::GetText](https://learn.microsoft.com/en-us/windows/win32/api/filter/nf-filter-ifilter-gettext)

[Using the IFilter interface to extract text from documents « The Lazy Programmer](https://web.archive.org/web/20130121011523/http://tlzprgmr.wordpress.com/2008/02/02/using-the-ifilter-interface-to-extract-text-from-documents/)
- [IFilter Part 3: Using Word Stemmers | The Lazy Programmer](https://web.archive.org/web/20140828095016/http://tlzprgmr.wordpress.com/2008/03/14/ifilter-part-3-using-word-stemmers/)
- [ferruccio/IFilter: source for IFilter series of blog posts](https://github.com/ferruccio/IFilter)

[Implementing a TextReader to extract various files contents using IFilter - CodeProject](https://www.codeproject.com/articles/31944/implementing-a-textreader-to-extract-various-files?fid=1532771&df=90&mpp=25&sort=Position&view=Normal&spc=Relaxed&prof=True&fr=26)

[Using IFilter in C# - CodeProject](https://www.codeproject.com/Articles/13391/Using-IFilter-in-C)
- COM threading issues

  > Since filters are essentially COM objects, they carry with them all the COM threading model issues that we all love to hate. See the [Links](https://www.codeproject.com/Articles/13391/Using-IFilter-in-C#Links) section for some of the reported problems. To make a long story short, some filters are marked as *STA* (Adobe PDF filter), some as *MTA* (Microsoft XML filter), and some as *Both* (Microsoft Office Filter). This means MTA filters will not load into C# threads that are marked with the `[STAThread]`, and STA filters will not load into `[MTAThread]` threads. Some people recommend manually changing the registry to mark "problematic" filters as *Both*, but this isn't something you want to do during the installation of a product, nor can you reliably do it because you don't know which filters are installed on the customer's machine. We basically need a way to load an IFilter and use it no matter what its threading model or our threading model is.

[full text search - How to use a specific PDF IFilter - Stack Overflow](https://stackoverflow.com/questions/2403960/how-to-use-a-specific-pdf-ifilter)

C++:
- [IFilter sample](https://github.com/microsoft/Windows-classic-samples/tree/main/Samples/Win7Samples/winui/WindowsSearch/IFilterSample)
- [IFilterExtractor: A simple component to extract just the text from any file that has an IFilter installed. Available as a C++ COM component and as a C# .NET library.](https://github.com/IDisposable/IFilterExtractor)

Rust:
- windows-rs: `Win32_Storage_IndexServer,Win32_System_Com,Win32_System_Com_StructuredStorage`

.NET:
- [IFilterTextReader: A reader that gets text from different file formats through the IFilter interface](https://github.com/Sicos1977/IFilterTextReader)
  - [IFilterCmd: A simple command line frontend for IFilterTextReader on GitHub](https://github.com/Dieter64/IFilterCmd)

### Tools
[Testing Filter Handlers - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/search/-search-ifilter-testing-filters)
- [filtreg.txt](../filtreg.txt)

### Handler implementations
- [Filter Handlers that Ship with Windows - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/search/-search-ifilter-implementations)
  - Plain Text: .a, .ahk, .ans, .asc, .asm, .asx, .bas, .bat, .bcp, .cc, .cls, .cmd, .cpp, .cs, .csa, .csv, .cxx, .dbs, .def, .dic, .dos, ...
    - But not `.md`
  - XML: .csproj, ...
  - HTML: `htmlfiles`, .ascx, .asp, aspx, .css, ...
    - `<title>` will not be indexed.
    - `abc` in `<!-- abc -->` will be indexed.
  - MIME: .eml, .mht, .mhtml
  - Document: `.doc`, `.mdb`, `.ppt`, `.xlt`, ...
  - Microsoft Office: .doc, ...
    - Office Open XML Format Word: .docm, .docx, ...
  - Reader Search: .pdf
  - Zip: `.zip` (at least available in Windows 11)
    - 支持文件名和内容
  - Favorites: `.url`
  - App Content: `.appcontent-ms`
  - Setting Content: `.settingcontent-ms`

- [iFilter4Archives: Windows Search iFilter for 7-Zip and other archives.](https://github.com/meitinger/iFilter4Archives)

  不知道是只能搜文件名还是内容也可以
- [WordPerfectIndexer: A Windows Search IFilter to index text from WordPerfect documents](https://github.com/SunburstApps/WordPerfectIndexer)


[^explorer-wiki]: [File Explorer - Wikipedia](https://en.wikipedia.org/wiki/File_Explorer)