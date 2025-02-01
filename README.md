<picture>
  <img width="500px" alt="Windows Essentials UWP" src="docs/logo.png">
</picture>

UWP packages for essential apps, also includes codecs.

## Table of Contents
- [Overview](#overview)
- [Usage](#usage)
- [License](#license)

## Overview
The repository contains an automated install script written for **Windows Powershell**. It also works with PowerShell Core.

Packages are organized into groups, here is a list of available groups and it's packages:
- `MediaFoundationCodecs`
  - `Microsoft.VCLibs.140.00`
  - `Microsoft.AV1VideoExtension`
  - `Microsoft.HEIFImageExtension`
  - `Microsoft.HEVCVideoExtension`
  - `Microsoft.MPEG2VideoExtension`
  - `Microsoft.RawImageExtension`
  - `Microsoft.WebMediaExtensions`
  - `Microsoft.WebpImageExtension`
  - `Microsoft.VP9VideoExtensions`
- `DevelopmentApps`
  - `Microsoft.WindowsTerminal`
- `WingetStandalone`
  - `Microsoft.DesktopAppInstaller`

> [!NOTE]
> `WingetStandalone` has been removed, and
> `DevelopmentApps` is yet to be available sooner.

## Usage
Run the install script via PowerShell:
```powershell
./install.ps1
```


## License
This repository is licensed under the Unlicense license, you can create an issue or make a pull request to have features changed. 
