# Virtualization-Based Security
在 Windows 10 中，微软利用 Hyper-V 虚拟化技术实现了**基于虚拟化的安全（Virtualization-Based Security，下称 VBS）**。在开启 VBS 时，系统会被划分为两个**虚拟信任级别（Virtual Trust Levels，下称 VTL）**：VTL 0 和 VTL 1。原本的 Windows 内核运行在权限受限的 VTL 0 中，而新的“安全内核”（Secure Kernel）则运行在权限不受限制的 VTL 1 中。这使得即使 Windows 内核和加载的相关驱动中存在漏洞，攻击者也无法获得系统的最高权限，因此也无法破坏掉安全内核中的安全组件。

安全内核中的安全组件有 Device Guard 和 Credential Guard，前者包括基于虚拟机的代码完整性（Hypervisor-based Code Integrity，HVCI）和内核代码完整性（Kernel-Mode Code Integrity，KMCI）；后者主要包括隔离本地安全认证（Isolated LSA）。“内核隔离”实际上就是 VBS的另一种称呼，而“内存完整性”则是 HVCI 的另一种称呼。

![](images/VBS.png)[^winter]
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

## Credential Guard
Credential Guard (LSAIso.exe) is used by Lsass (if so configured on supported Windows 10 and Server 2016 systems) to store users’ token hashes instead of keeping them in Lsass’s memory. Because Lsaiso.exe is a Trustlet (Isolated User Mode process) running in VTL 1, no normal process - not even the normal kernel - can access the address space of this process. Lsass itself stores an encrypted blob of the password hash needed when it communicates with Lsaiso (via ALPC).[^winter]

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
      - Select Platform Security Level (Secure Boot and DMA Protection)
      - Virtualization Based Protection of Code Integrity
      - Credential Guard Configuration

To disable VBS without disabling Hyper-V, run the following commands after turning off all VBS Group Policy and registry settings[^ms-credential][^disable-ms-qa][^disable-su]:
```cmd
mountvol X: /s
copy %WINDIR%\System32\SecConfig.efi X:\EFI\Microsoft\Boot\SecConfig.efi /Y
bcdedit /create {0cb3b571-2f2e-4343-a879-d86a476d7215} /d "Disable VBS" /application osloader
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} path "\EFI\Microsoft\Boot\SecConfig.efi"
bcdedit /bootsequence {0cb3b571-2f2e-4343-a879-d86a476d7215}
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-VBS
bcdedit /set vsmlaunchtype off
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} device partition=X:
mountvol X: /d
```
- [`mountvol X: /s` The parameter is incorrect. - Issue #6858 - MicrosoftDocs/windows-itpro-docs](https://github.com/MicrosoftDocs/windows-itpro-docs/issues/6858)

  Can only be used with UEFI.

However, while `bcdedit /bootsequence` works, `bcdedit /default` does not, which means we can only disable VBS for the next boot. A workaround is to use Task Scheduler to run `bcdedit.exe /bootsequence {0cb3b571-2f2e-4343-a879-d86a476d7215}` after every boot.

At boot you should see the "Virtualization Based Security Opt-out Tool" asking you whether to disable VBS. Press Win or F3 to continue and reboot to the real system.

[^winter]: *Windows Internals*

[^disable-ms-qa]: [Disable Virtualization-Based Security Without Disabling Hyper-V - Microsoft Q&A](https://docs.microsoft.com/en-us/answers/questions/245071/disable-virtualization-based-security-without-disb.html)
[^disable-su]: [hyper v - Windows 10: Permanently disable VBS (Virtualization-based security)? - Super User](https://superuser.com/questions/1489224/windows-10-permanently-disable-vbs-virtualization-based-security)

[^ms-integrity]: [Enable virtualization-based protection of code integrity - Windows security | Microsoft Docs](https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity)
[^ms-credential]: [Manage Windows Defender Credential Guard (Windows) - Windows security | Microsoft Docs](https://docs.microsoft.com/en-us/windows/security/identity-protection/credential-guard/credential-guard-manage)