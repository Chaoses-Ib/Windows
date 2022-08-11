# Virtualization-Based Security
![](images/VBS.png)[^internals]
- [I/O memory management unit](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit)
- [Second Level Address Translation](https://en.wikipedia.org/wiki/Second_Level_Address_Translation)
- Secure boot
- Secure kernel (`securekernel.exe`)
  - Device Guard
    - Hypervisor-based Code Integrity (HVCI)
    - Kernel-Mode Code Integrity (KMCI)
  - Credential Guard
    - LSA (`Lsass.exe`)
    - Isolated LSA (`LsaIso.exe`)
- Isolated user mode (`Iumdll.dll` and `Iumbase.dll`, the VTL 1 version of `Ntdll.dll` and `Kernelbase.dll`)
  - Trustlets

[^internals]: *Windows Internals*

## Credential Guard
Credentials:
- Password
- NT one-way function (used by the NT LAN Manager protocol)
- Ticket-granting ticket (used by the Kerberos protocol)

## Performance impacts
VBS can cause performance drops of 5% to 30%.[^pcgamer][^toms]

[^pcgamer]: [Windows 11 will hobble gaming performance by default on some prebuilt PCs | PC Gamer](https://www.pcgamer.com/windows-11-pcs-can-hobble-gaming-performance/)
[^toms]: [Benchmarked: Do Windows 11’s Security Features Really Hobble Gaming Performance? | Tom's Hardware](https://www.tomshardware.com/news/windows-11-gaming-benchmarks-performance-vbs-hvci-security)

## Configuration
[^ms-integrity][^ms-credential]
- `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control`
  - DeviceGuard
    - EnableVirtualizationBasedSecurity
    - RequirePlatformSecurityFeatures
    - Scenarios
      - HypervisorEnforcedCodeIntegrity
      - CredentialGuard
  - Lsa
    - LsaCfgFlags
- Group Policy (`gpedit.msc`)
  - Computer Configuration/Administrative Templates/System/Device Guard
    - Turn on Virtualization Based Security
      - Secure Boot and DMA Protection
      - Virtualization Based Protection of Code Integrity
      - Credential Guard Configuration

Disable VBS without disabling Hyper-V：
- [Disable Virtualization-Based Security Without Disabling Hyper-V - Microsoft Q&A](https://docs.microsoft.com/en-us/answers/questions/245071/disable-virtualization-based-security-without-disb.html)
- [hyper v - Windows 10: Permanently disable VBS (Virtualization-based security)? - Super User](https://superuser.com/questions/1489224/windows-10-permanently-disable-vbs-virtualization-based-security)

[^ms-integrity]: [Enable virtualization-based protection of code integrity - Windows security | Microsoft Docs](https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity)
[^ms-credential]: [Manage Windows Defender Credential Guard (Windows) - Windows security | Microsoft Docs](https://docs.microsoft.com/en-us/windows/security/identity-protection/credential-guard/credential-guard-manage)