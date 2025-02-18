# Licensing
[Microsoft Software Licensing and Protection Services - Wikipedia](https://en.wikipedia.org/wiki/Microsoft_Software_Licensing_and_Protection_Services)

## Windows
- HWID
  - > All activations can be linked to a Microsoft account without any issues.
  - Not supported by Windows Server

- TSforge
  - ESU
  - > In addition to activation, it can reset the rearm count and evaluation period, clear the tamper state, and remove the evaluation key lock.

  [TSforge | MAS](https://massgrave.dev/blog/tsforge)

- KMS38
  - 2038-01-19

- Online KMS
  - 180 days

- [CLiP](#client-licensing-platform-clip)

### Tools
- [Microsoft Activation Scripts (MAS)](https://massgrave.dev/)
  - `irm https://get.activated.win | iex`

- [TGSAN/CMWTAT\_Digital\_Edition: CloudMoe Windows 10/11 Activation Toolkit get digital license, the best open source Win 10/11 activator in GitHub. GitHub 上最棒的开源 Win10/Win11 数字权利（数字许可证）激活工具！](https://github.com/TGSAN/CMWTAT_Digital_Edition)
  - HWID

- [abbodi1406/KMS\_VL\_ALL\_AIO: Smart Activation Script](https://github.com/abbodi1406/KMS_VL_ALL_AIO)
  - KMS38, KMS

- KMS
  - [沧水的KMS服务](https://kms.cangshui.net/)
  - [kkkgo/KMS\_VL\_ALL: 🔑KMS\_VL\_ALL - Smart Activation Script](https://github.com/kkkgo/KMS_VL_ALL) (discontinued)

## Client Licensing Platform (CLiP)
> This system was introduced with Windows 10, primarily as a way to implement DRM for Microsoft Store apps, and integrated with Windows activation, allowing users to buy digital licenses for Windows on the Microsoft Store.

- Keyhole

  微软商店的网络验证直接把 ed25519 的私钥放程序里了，waybird 混淆过但又可以下载到符号，然后还有个解析漏洞，加起来可以破解微软商店里的所有商品，xbox 似乎也有一样的漏洞。

  [Keyhole | MAS](https://massgrave.dev/blog/keyhole) ([Hacker News](https://news.ycombinator.com/item?id=41472643), [r/ReverseEngineering](https://www.reddit.com/r/ReverseEngineering/comments/1fb553t/keyhole_mas/))
  > Yes, literally. A valid ECDSA key to sign XML licenses is stored in unobfuscated form, allowing anyone to very easily sign or resign XML licenses. This key is normally meant to sign temporary licenses sent to the Microsoft store to get digital licenses, but ClipSvc will happily accept it for app licenses as well.

  > There's only one big issue: most of the interesting driver code is hidden using Microsoft's proprietary obfuscator, known as Warbird. In order to find and understand it, we need to "unpack" it, a.k.a. undoing the obfuscation. Luckily, this is rather straightforward thanks to some symbols for `clipsp.sys` that were available on Microsoft's servers.

  > As for the fix itself, it's rather straightforward. As shown below, the current license block parser code immediately exits after encountering a signature block. This prevents it from processing blocks after the signature, completely patching Keyhole.

  > And there's the same bug that's in CLiP, but in Xbox code. In fact, we weren't too surprised to find this, as we found that almost all of CLiP, from the XML format of the licenses to the TLV-based license blocks, is copy-pasted straight from the Xbox One's DRM system.
