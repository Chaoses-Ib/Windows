# Processes
## Process ID
[Wikipedia](https://en.wikipedia.org/wiki/Process_identifier#Microsoft_Windows)

- `GetProcessId()`
- [`GetCurrentProcessId()`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentprocessid)
- `GetProcessIdOfThread()`
- TEB
  - `ClientId`
  - `RealClientId`

[Fourteen Ways to Read the PID for the Local Security Authority Subsystem Service (LSASS) - MDSec](https://www.mdsec.co.uk/2022/08/fourteen-ways-to-read-the-pid-for-the-local-security-authority-subsystem-service-lsass/)

[Project Zero: Windows‌ ‌Exploitation‌ ‌Tricks:‌ ‌Spoofing‌ ‌Named‌ ‌Pipe‌ ‌Client‌ ‌PID‌](https://googleprojectzero.blogspot.com/2019/09/windows-exploitation-tricks-spoofing.html)

Tools:
- [Finding the Process ID - Windows drivers | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/finding-the-process-id)

## Process injection
Approaches[^inject-2019]:
- [DLL injection](DLLs/README.md#dll-injection)
- [COM hijacking](../../Applications/API/COM/README.md#hijacking)
- Thread
  - CreateRemoteThread()
  - SetThreadContext()
  - [APCs](../Traps/Asynchronous%20Procedure%20Calls.md)
    - [AtomBombing](https://www.fortinet.com/blog/threat-research/atombombing-brand-new-code-injection-technique-for-windows)
    - [StackBomber](https://www.blackhat.com/docs/eu-15/materials/eu-15-Chen-Hey-Man-Have-You-Forgotten-To-Initialize-Your-Memory.pdf)
- Window
  - SetWindowLongPtr()
  - KernelCallbackTable
    - [__fnCOPYDATA](https://www.microsoft.com/security/blog/2018/03/01/finfisher-exposed-a-researchers-tale-of-defeating-traps-tricks-and-complex-virtual-machines/)
  - SetProp()
    - UxSubclassInfo ([PROPagate](http://www.hexacorn.com/blog/2017/10/26/propagate-a-new-code-injection-trick/))
    - [CLIPBRDWNDCLASS](https://modexp.wordpress.com/2019/05/24/4066/)
  - USERDATA
    - [ConsoleWindowClass](https://modexp.wordpress.com/2018/09/12/process-injection-user-data/)
  - [WNF_SHEL_APPLICATION_STARTED](http://www.hexacorn.com/blog/2019/06/12/code-execution-via-surgical-callback-overwrites-e-g-dns-memory-functions/)
- NtUnmapViewOfSection()
- [ALPC](https://modexp.wordpress.com/2019/03/07/process-injection-print-spooler/)
- [Service Control Handler](https://modexp.wordpress.com/2018/08/30/windows-process-injection-control-handler/)
- [DnsQuery](http://www.hexacorn.com/blog/2019/06/12/code-execution-via-surgical-callback-overwrites-e-g-dns-memory-functions/)
- SingleHandler (Ctrl-Inject)

[^inject-2019]: Klein, Amit, Itzik Kotler, and Safebreach Labs. “Windows Process Injection in 2019,” n.d., 34.