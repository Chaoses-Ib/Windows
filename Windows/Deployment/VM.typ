#import "@local/ib:0.1.0": *
#title[Windows Virtual Machines (VM)]
- Windows
  #footnote[#a[docker - Can Windows containers be hosted on Linux? - Stack Overflow][https://stackoverflow.com/questions/42158596/can-windows-containers-be-hosted-on-linux]]
  \+ Windows containers

  #a[microsoft/windows-servercore - Docker Image][https://hub.docker.com/r/microsoft/windows-servercore]

  #a[We made Windows Server Core container images >40% smaller - .NET Blog][https://devblogs.microsoft.com/dotnet/we-made-windows-server-core-container-images-40-smaller/]

- #a([Docker containers], <docker>)

- #a[quickemu-project/quickemu: Quickly create and run optimised Windows, macOS and Linux virtual machines][https://github.com/quickemu-project/quickemu]
  - #a[04 Create Windows virtual machines - quickemu-project/quickemu Wiki][https://github.com/quickemu-project/quickemu/wiki/04-Create-Windows-virtual-machines]
  - RDP defaults to username `Quickemu` and password `quickemu`.

- Incus

  #a[Windows Server Core VM and share folder - Incus - Linux Containers Forum][https://discuss.linuxcontainers.org/t/windows-server-core-vm-and-share-folder/26075]

See also #a[Minimal Windows][https://github.com/Chaoses-Ib/Windows/blob/main/Windows/Minimal/README.typ].

#a[How viable is it to use a Windows Virtual Machine in Linux? : r/linuxquestions][https://www.reddit.com/r/linuxquestions/comments/144nvkt/how_viable_is_it_to_use_a_windows_virtual_machine/]

#a[Running Windows 10 in a VM on Linux Mint with KVM, QEMU, and Virt-Manager - Nathan Manzi][https://nmanzi.com/posts/windows-guest-on-linux-mint/]

= Docker containers <docker>
- dockur/windows
- #a[qemus/qemu: QEMU in a Docker container.][https://github.com/qemus/qemu]

Vagrant:
- #a[StefanScherer/windows-docker-machine: Work with Windows containers and LCOW on Mac/Linux/Windows][https://github.com/StefanScherer/windows-docker-machine]
- #a[vaggeliskls/windows-in-docker-container: Deploy and manage a Windows OS (x64) seamlessly using Vagrant VM, libvirt, and docker-compose. This innovative approach integrates smoothly into existing workflows, providing an efficient way of containerizing Windows OS for better resource allocation and convenience.][https://github.com/vaggeliskls/windows-in-docker-container]

== #a[dockur/windows: Windows inside a Docker container.][https://github.com/dockur/windows]
- Disk
  - ```sh -e "DISK_SIZE=32G"```
  - Sparse file.

- Images/Versions
  - Will re-download the ISO image every time.
  - Server Core: ```sh -e "VERSION=2019" -e "EDITION=CORE"```
    #footnote[#a[\[Feature\]: What about support for Windows Nano Server or Windows Server Core - Issue \#556 - dockur/windows][https://github.com/dockur/windows/issues/556]]
    #footnote[#a[\[Feature\]: Flag to install Windows Server Core. Windows Server without desktop. - Issue \#1030 - dockur/windows][https://github.com/dockur/windows/issues/1030]]
  - #a[\[Feature\]: Add support for Windows 11 IoT version - Issue \#1431][https://github.com/dockur/windows/issues/1431]
  - #a[\[Feature\]: Support for debloat windows - Issue \#1258][https://github.com/dockur/windows/issues/1258]

- `RAM_SIZE`'s unit is GiB.
  - Hardware reserved: 19.6 MB
  - ```sh RAM_SIZE=0.2890625G``` / ```sh RAM_SIZE=296M```

- VirtIO
  - #a[Samba][https://github.com/dockur/windows/blob/master/src/samba.sh]
    - #a[wsdd-native: Make your macOS/Linux/BSD/illumos/HaikuOS machine visible in Network view of Windows Explorer][https://github.com/gershnik/wsdd-native]
    - ```sh -v "${PWD:-.}/shared:/shared"```
    - `/shared` $arrow$ `\\host.lan\Data`, `%USERPROFILE%\Desktop\Shared`
    - `/shared2` $arrow$ `\Data2`, `/shared3` $arrow$ `\Data3`
      #footnote[#a[\[Feature\]: Multiple shared directories - Issue \#613 - dockur/windows][https://github.com/dockur/windows/issues/613]]
      #footnote[#a[feat: Support multiple shared folders (\#810) - dockur/windows\@815a3f3][https://github.com/dockur/windows/commit/815a3f3c6637e617a0b121510cf43267c9586f4c]]
    - #strike[
      Even running as `root`, only files of the same owner are visible?
      ]\
      #a[\[Bug\]: File synchronization exception in shared folder - Issue \#1233][https://github.com/dockur/windows/issues/1233]

      ```cmd
      reg add HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters /t REG_DWORD /v DirectoryCacheLifetime /d 0 /f
      ```
      #a[SMB2 Client Redirector Caches Explained | Microsoft Learn][https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-7/ff686200(v=ws.10)]
  - Virtio-fs
    
    #a[[Feature]: Yet another virtiofs request - Issue \#1303][https://github.com/dockur/windows/issues/1303]

- Networks
  - ```sh USER_PORTS=22,3389```

    #a[\[Bug\]: Non-standard network ports are not accessible - Issue \#1503][https://github.com/dockur/windows/issues/1503]
  - #a[[Bug]: `NET_RAW` capability is needed for RDP in some cases - Issue \#1648][https://github.com/dockur/windows/issues/1648]

- VNC (`8006`) has no password.

- RDP
  - RDP defaults to username `Docker` and password `admin`.
  - ```sh -e "USERNAME=ib" -e "PASSWORD=0721"```

- SSH
  - #a[\[Feature\]: Preconfigured SSH - Issue \#428][https://github.com/dockur/windows/issues/428]
  - #a[`containerd/script/setup/enable_ssh_windows.ps1` - containerd/containerd][https://github.com/containerd/containerd/blob/7cd7a5c82f4a9483363079fb1da3e414f8003ed5/script/setup/enable_ssh_windows.ps1]
  - #a[\[Feature\]: options to install and setup openssh - Issue \#995][https://github.com/dockur/windows/issues/995]
  - #a[OpenSSH on the container - Issue \#1340][https://github.com/dockur/windows/issues/1340]

Windows 2019 Core:
```sh
$ mkdir win2019
$ podman run -it --name win2019 --rm -e "VERSION=2019" -e "EDITION=CORE" -e "DISK_SIZE=32G" -e "RAM_SIZE=2G" -e "USERNAME=ib" -e "PASSWORD=0721" -p 127.0.0.1:8006:8006 -p 3390:3389/tcp -p 3390:3389/udp --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN --cap-add NET_RAW -v "${PWD:-.}/win2019:/storage" -v "${PWD:-.}/shared:/shared" --stop-timeout 120 docker.io/dockurr/windows
❯ Starting Windows for Podman v5.14...
❯ For support visit https://github.com/dockur/windows
❯ CPU: AMD Ryzen 9 9950X | RAM: 14/16 GB | DISK: 290 GB (ext4) | KERNEL: 6.12.63+deb13-amd64...

❯ Requesting Windows Server 2019 from the Microsoft servers...
❯ Downloading Windows Server 2019...
/storage/tmp/win2019-eval.iso                      100%[================================================================================================================>]   5.26G  7.56MB/s    in 19m 17s 
❯ Extracting Windows Server 2019 image...
❯ Adding drivers to image...
❯ Adding win2019-eval.xml for automatic installation...
❯ Building Windows Server 2019 image...
❯ Creating a 32 GB growable disk image in raw format...

# dnsmasq: process is missing required capability NET_RAW
❯ Notice: because user-mode networking is active, when you need to forward custom ports to Windows, add them to the "USER_PORTS" variable.
❯ Nested KVM virtualization detected..
❯ Booting Windows securely using QEMU v10.0.6...
qemu-system-x86_64: warning: host doesn't support requested feature: CPUID.80000007H:EDX.invtsc [bit 8]
qemu-system-x86_64: warning: host doesn't support requested feature: CPUID.80000007H:EDX.invtsc [bit 8]
BdsDxe: skipped Boot0002 "UEFI QEMU QEMU HARDDISK " from PciRoot(0x0)/Pci(0xA,0x0)/Scsi(0x0,0x0)
BdsDxe: loading Boot0001 "UEFI QEMU DVD-ROM QM00013 " from PciRoot(0x0)/Pci(0x5,0x0)/Sata(0x0,0xFFFF,0x0)
BdsDxe: starting Boot0001 "UEFI QEMU DVD-ROM QM00013 " from PciRoot(0x0)/Pci(0x5,0x0)/Sata(0x0,0xFFFF,0x0)
❯ Windows started successfully, visit http://127.0.0.1:8006/ to view the screen...
BdsDxe: loading Boot0003 "Windows Boot Manager" from HD(1,GPT,C61AA66C-8B09-4E59-AC17-705483FAB5F1,0x800,0x40000)/\EFI\Microsoft\Boot\bootmgfw.efi
BdsDxe: starting Boot0003 "Windows Boot Manager" from HD(1,GPT,C61AA66C-8B09-4E59-AC17-705483FAB5F1,0x800,0x40000)/\EFI\Microsoft\Boot\bootmgfw.efi
BdsDxe: loading Boot0003 "Windows Boot Manager" from HD(1,GPT,C61AA66C-8B09-4E59-AC17-705483FAB5F1,0x800,0x40000)/\EFI\Microsoft\Boot\bootmgfw.efi
BdsDxe: starting Boot0003 "Windows Boot Manager" from HD(1,GPT,C61AA66C-8B09-4E59-AC17-705483FAB5F1,0x800,0x40000)/\EFI\Microsoft\Boot\bootmgfw.efi

❯ Received SIGINT, sending ACPI shutdown signal...
❯ Waiting for Windows to shutdown... (1/110)
❯ Shutdown completed!
```
- Disk: 6.82 GB
- RAM: 600 (800) MB

#a[Windows in a Docker container : r/selfhosted][https://www.reddit.com/r/selfhosted/comments/19771wv/windows_in_a_docker_container/]
