# Thread Priority
- 0~31 (highest)
- Process priority class (base priority)
- Dynamic priority

> Normally, user applications and services start with a normal base priority, so their initial thread typically executes at priority level 8. However, some Windows system processes (such as the Session manager, Service Control Manager, and local security authentication process) have a base process priority slightly higher than the default for the Normal class (8). This higher default value ensures that the threads in these processes will all start at a higher priority than the default value of 8.[^yosifovichWindowsInternalsSystem2017]

[Thread Priorities in Windows -- Pavel Yosifovich](https://scorpiosoftware.net/2023/07/14/thread-priorities-in-windows/)

API:
- [SetPriorityClass function (processthreadsapi.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setpriorityclass)
- [SetThreadPriority function (processthreadsapi.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreadpriority)

Rust:
- [thread-priority: A simple Cross-platform thread schedule and priority library for rust.](https://github.com/iddm/thread-priority)

[Is there a way to run an application with a different cpu priority in windows? : r/rust](https://www.reddit.com/r/rust/comments/enstuv/is_there_a_way_to_run_an_application_with_a/)

## Tools
- Task Manager
- Process Explorer
- [Windows System Resource Manager (WSRM)](#windows-system-resource-manager-wsrm)
- [YemowtRonoc/process-priority-manager: Set Process Priority on Windows devices](https://github.com/YemowtRonoc/process-priority-manager)
- [artumino/minosse: A windows service written in rust that monitors processes and changes their affinity and priority based on user defined rules](https://github.com/artumino/minosse)

### Windows System Resource Manager (WSRM)
> It permits the administrator to configure policies that specify CPU utilization, affinity settings, and memory limits (both physical and virtual) for processes. In addition, WSRM can generate resource-utilization reports that can be used for accounting and verification of service-level agreements with users.
> 
> Policies can be applied for specific applications (by matching the name of the image with or without specific command-line arguments), users, or groups. The policies can be scheduled to take effect at certain periods or can be enabled all the time.
> 
> After you set a resource-allocation policy to manage specific processes, the WSRM service monitors CPU consumption of managed processes and adjusts process base priorities when those processes do not meet their target CPU allocations.
> 
> The physical memory limitation uses the function `SetProcessWorkingSetSizeEx` to set a hard-working set maximum. The virtual memory limit is implemented by the service checking the private virtual memory consumed by the processes. If this limit is exceeded, WSRM can be configured to either kill the processes or write an entry to the event log. This behavior can be used to detect a process with a memory CHAPTER 4 Threads 223  leak before it consumes all the available committed memory on the system. Note that WSRM memory limits do not apply to Address Windowing Extensions (AWE) memory, large page memory, or kernel memory (non-paged or paged pool).[^yosifovichWindowsInternalsSystem2017]

## I/O priority
> I/O has a default priority of Normal, and the memory manager uses Critical when it wants to write dirty memory data out to disk under low-memory situations to make room in RAM for other data and code. The Windows Task Scheduler sets the I/O priority for tasks that have the default task priority to Very Low. The priority specified by applications that perform background processing is Very Low. All the Windows background operations, including Windows Defender scanning and desktop search indexing, use Very Low I/O priority.[^yosifovichWindowsInternalsSystem2017]

[I/O Prioritization in Windows OS. I/O prioritization improves the... | by Milad Kahsari Alhadi | Medium](https://clightning.medium.com/i-o-prioritization-in-windows-os-6a0637874a52)

[How to set a I/O Priority of a Windows Process to High as Process Lasso does - Stack Overflow](https://stackoverflow.com/questions/73106122/how-to-set-a-i-o-priority-of-a-windows-process-to-high-as-process-lasso-does)

## [→Page priority](https://github.com/Chaoses-Ib/InformationSystems/blob/main/Memory/Virtual/Priority.md)


[^yosifovichWindowsInternalsSystem2017]: Yosifovich, P., Ionescu, A., Solomon, D. A., & Russinovich, M. E. (2017). Windows Internals: System architecture, processes, threads, memory management, and more, Part 1. Microsoft Press. https://books.google.com/books?hl=en&lr=&id=y83LDgAAQBAJ&oi=fnd&pg=PA1999&dq=Windows+Internals
