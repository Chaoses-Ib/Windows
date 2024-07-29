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

## Parent process
[Parent Process vs. Creator Process -- Pavel Yosifovich](https://scorpiosoftware.net/2021/01/10/parent-process-vs-creator-process/)

Parent process ID:
- `NtQueryInformationProcess()` → `PROCESS_BASIC_INFORMATION.InheritedFromUniqueProcessId` (`Reserved3`)
  
  C++:
  - [IbProcessGuard](https://github.com/Chaoses-Ib/IbProcessGuard/blob/8789711d9a8a6d3083b575f62548fb3a4bb00727/IbParentProcessGuard/Main.cpp#L51-L56)
  - [windows 下获取父进程pid - 纯白、色 - 博客园](https://www.cnblogs.com/jkcx/p/7457339.html)
  
  Rust:
  - ~~`std`~~: There is `parent_id()` in `std::os::unix::process`, but not in `std::os::windows::process`.
  - [sysinfo](https://github.com/GuillaumeGomez/sysinfo/blob/3cc3df817d3f3c1118ae8bcc438c5ca1c29c016e/src/windows/process.rs#L808-L829)

    `cargo add sysinfo --no-default-features`
    ```rust
    let mut system = sysinfo::System::new();
    let current_pid = sysinfo::get_current_pid().unwrap();
    system.refresh_process_specifics(current_pid, sysinfo::ProcessRefreshKind::new());
    let parent_pid = system.process(current_pid).unwrap().parent().unwrap();

    system.refresh_process_specifics(parent_pid, sysinfo::ProcessRefreshKind::new());
    if let Some(parent) = system.process(parent_pid) {
        parent.wait();
    }
    ```

- `CreateToolhelp32Snapshot()`

  ```cpp
  #include <Windows.h>
  #include <TlHelp32.h>
  #include <iostream>

  DWORD GetParentProcessId(DWORD pid) {
      DWORD ppid = -1;
      HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      if (hSnapshot != INVALID_HANDLE_VALUE) {
          PROCESSENTRY32 pe;
          pe.dwSize = sizeof(PROCESSENTRY32);
          if (Process32First(hSnapshot, &pe)) {
              do {
                  if (pe.th32ProcessID == pid) {
                      ppid = pe.th32ParentProcessID;
                      break;
                  }
              } while (Process32Next(hSnapshot, &pe));
          }
          CloseHandle(hSnapshot);
      }
      return ppid;
  }

  int main() {
      DWORD pid = GetCurrentProcessId();
      DWORD ppid = GetParentProcessId(pid);
      std::wcout << L"Parent PID: " << ppid << std::endl;
      return 0;
  }
  ```

- WMI

Tools:
- PowerShell: `(Get-Process).Parent.Id`

  [Powershell how to get the ParentProcessID by the ProcessID - Stack Overflow](https://stackoverflow.com/questions/33911332/powershell-how-to-get-the-parentprocessid-by-the-processid)

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

[Windows Persistence - Amr Ashraf](https://amr-git-dot.github.io/offensive/persistence/)

[MahmoudZohdy/Process-Injection-Techniques: Various Process Injection Techniques](https://github.com/MahmoudZohdy/Process-Injection-Techniques)

[^inject-2019]: Klein, Amit, Itzik Kotler, and Safebreach Labs. “Windows Process Injection in 2019,” n.d., 34.