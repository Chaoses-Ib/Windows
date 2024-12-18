# Services
[Wikipedia](https://en.wikipedia.org/wiki/Windows_service)

- Control: Start, stop, pause, restart
- Startup type
- Recovery actions
- Security
  - User account
  - [Windows Service Hardening](#windows-service-hardening)
- Service dependencies

[c# - When do we use windows service? - Stack Overflow](https://stackoverflow.com/questions/2884132/when-do-we-use-windows-service)

[operating systems - Windows Console App vs Service - Software Engineering Stack Exchange](https://softwareengineering.stackexchange.com/questions/218958/windows-console-app-vs-service)

## Development
- SrvAny (Windows Resource Kit)
  - [srvany-ng: Run any Windows application as a Service. Drop-in compatible replacement for "srvany.exe" from the W2K3 Resource Kit.](https://github.com/birkett/srvany-ng)
- [NSSM - the Non-Sucking Service Manager](https://nssm.cc/)
  - Size: 1.8 MiB

Rust:
- [windows-service-rs: Windows services in Rust](https://github.com/mullvad/windows-service-rs)
  - [Shawl: Windows service wrapper for arbitrary commands](https://github.com/mtkennerly/shawl)
    - By default, when your program exits, Shawl will restart it if the exit code is nonzero. If you want to use the service recovery feature of Windows itself when Shawl gives up trying to restart the wrapped command, then make sure to turn on the "enable actions for stops with errors" option in the service properties.
    - Size: 3.2 MiB

    > Shawl differs from existing solutions like WinSW and NSSM in that they require running a special install command to prepare the service. That can be inconvenient in cases like installing a service via an MSI, where you would need to run a `CustomAction`. With Shawl, you can configure the service however you want, such as with the normal MSI `ServiceInstall` or by running `sc create`, because Shawl doesn't have any special setup of its own. The `shawl add` command is just an optional convenience.

    [Shawl: run any program as a Windows service : r/rust](https://www.reddit.com/r/rust/comments/dbaryx/shawl_run_any_program_as_a_windows_service/)
    > At a high level, NSSM aims to be an all-in-one tool for creating/editing/running all services and for wrapping non-service-aware programs, whereas Shawl is focused on the wrapper part. That means something like NSSM's management GUI is a non-goal for Shawl. This manifests itself in a few specific ways, mainly pertaining to service setup:
    > - NSSM requires you to use its `nssm install` command to set up a service, or at least I didn't see an alternative in the documentation. My initial use case was configuring a service with an MSI, and I really wanted to avoid running a `CustomAction` (console command) instead of the standard `ServiceInstall` declaration (managed by the MSI/Windows directly), since `ServiceInstall` gives you rollback by default on uninstall.
    > - After the service is created, if you run `sc qc the-service`, the `BINARY_PATH_NAME` will just point to `nssm.exe` without any arguments, even if you configured it with arguments for your program. To see the arguments, it seems that you have to run an NSSM command to inspect the service, rather than being able to see what it does through `sc` or other standard Windows tools. With Shawl, the `BINARY_PATH_NAME` directly shows you the command that it will run and any options given to Shawl.
    > 
    > These differences were important to me for my use case, but if you're already happily using NSSM, then there might not be enough reason to switch at this point.

  - [universal-service-rs: A Rust crate that provides building blocks for creating service binaries across operating system platforms.](https://github.com/oko/universal-service-rs) ([Docs.rs](https://docs.rs/universal-service/latest/universal_service/))
    - [fix: Cargo.toml repository by Chaoses-Ib - Pull Request #1](https://github.com/oko/universal-service-rs/pull/1)

    > For Windows users, this library provides support for running services under the Windows Service manager directly, rather than requiring Scheduled Tasks hacks or NSSM.

- [windows-service-detector-rs: A Rust crate that provides Windows Service runtime environment detection.](https://github.com/oko/windows-service-detector-rs)

.NET:
- [WinSW: A wrapper executable that can run any executable as a Windows service, in a permissive license.](https://github.com/winsw/winsw)
  - 0.67 MiB (.NET Framework)

[Service wrapper - Wikipedia](https://en.wikipedia.org/wiki/Service_wrapper)

## Debugging
[How to: Debug Windows Service Applications - .NET Framework | Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/how-to-debug-windows-service-applications)
> A service must be run from within the context of the Services Control Manager rather than from within Visual Studio. For this reason, debugging a service is not as straightforward as debugging other Visual Studio application types. To debug a service, you must start the service and then attach a debugger to the process in which it is running.

> Debugging the [OnStart](https://learn.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicebase.onstart) method can be difficult because the Services Control Manager imposes a 30-second limit on all attempts to start a service. For more information, see [Troubleshooting: Debugging Windows Services](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/troubleshooting-debugging-windows-services).

Or just [run the service as a console program](#console).

## Console
- An executable can support being run as a service or as a console program at the same time.
  - .NET: [How to: Run a Windows Service as a console application](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/how-to-debug-windows-service-applications#how-to-run-a-windows-service-as-a-console-application)
  - Rust: universal-service-rs

- But when the executable is running as a service, its console outputs cannot be read.

  [c# 4.0 - How do you read the console output from windows service? - Stack Overflow](https://stackoverflow.com/questions/8502780/how-do-you-read-the-console-output-from-windows-service)
  > When run as a service the executable is started by the Service Control Manager (SCM), and there is no access to standard output, error or input.

  [c# - Console.WriteLine() inside a Windows Service? - Stack Overflow](https://stackoverflow.com/questions/8792978/console-writeline-inside-a-windows-service)
  > The output was always discarded until Windows Server 2008R2. Leave a console.writeline() in a service installed on that OS, and you'll get an error 1067 when starting/running the service, depending on the position of the writeline().

  Some wrappers will redirect the console outputs to files.

> As of version 2.22, *nssm* will by default create a new console window for the application. This allows some programs to work which would otherwise fail, such as those which expect to be able to read user input. The console window can be disabled if it is not needed by setting the integer (REG\_DWORD) value **AppNoConsole** under **HKLM\\System\\CurrentControlSet\\Services\\*servicename*\\Parameters** to a non-zero value.
>
> In the simplest case, *nssm* is not configured with any I/O redirection. It will launch the application with stdin, stdout and stderr connected to a console instance. If the service runs under the LOCALSYSTEM account and is configured to interact with the desktop, you may be able to view the output directly.

## Interactive services
[Interactive Services - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/interactive-services)
> Services cannot directly interact with a user as of Windows Vista.

## Windows Service Hardening
[Wikipedia](https://en.wikipedia.org/wiki/Security_and_safety_features_new_to_Windows_Vista#Windows_Service_Hardening)

> Services are now assigned a per-service Security identifier (SID), which allows controlling access to the service as per the access specified by the security identifier.
>
> Services in Windows Vista also run in a less privileged account such as *Local Service* or *Network Service*, instead of the *System* account. Previous versions of Windows ran system services in the same login session as the locally logged-in user (Session 0). In Windows Vista, Session 0 is now reserved for these services, and all interactive logins are done in other sessions. This is intended to help mitigate a class of exploits of the Windows message-passing system, known as [Shatter attacks](https://en.wikipedia.org/wiki/Shatter_attack "Shatter attack"). The process hosting a service has only the privileges specified in the *RequiredPrivileges* registry value under `HKLM\System\CurrentControlSet\Services`.
>
> Services also need explicit write permissions to write to resources, on a per-service basis. By using a write-restricted access token, only those resources which have to be modified by a service are given write access, so trying to modify any other resource fails. Services will also have pre-configured firewall policy, which gives it only as much privilege as is needed for it to function properly. Independent software vendors can also use Windows Service Hardening to harden their own services. Windows Vista also hardens the named pipes used by RPC servers to prevent other processes from being able to hijack them.

## Service names
[ServiceName | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/mscs/generic-services-servicename)

[Default service name conflicts with Microsoft (pmem) - Issue #53 - Velocidex/WinPmem](https://github.com/Velocidex/WinPmem/issues/53)

## Management
- sc
- PowerShell
- nssm
