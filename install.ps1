"Windows Essentials UWP"
"`n"

# Starting with PowerShell 7.1, Appx module is no longer imported by default
# so we have to manually import it ourselves in order to install a package
If (
    $PSVersionTable.PSVersion.Major -Eq 7 `
        -and
    $PSVersionTable.PSVersion.Minor -Ge 0) {
    Write-Verbose "Importing Appx module"
    Import-Module Appx -UseWindowsPowershell
    "`n"
}

## Locate certain directories & the script's resource file
Set-Variable weuRootDir $PSScriptRoot -Option Constant -ErrorAction SilentlyContinue
Set-Variable weuInstallDir $env:TEMP -Option Constant -ErrorAction SilentlyContinue

$weuResourceFile = Join-Path $weuRootDir "resources.json"

Write-Verbose "Install directory: $weuInstallDir"
Write-Verbose "Root directory: $weuRootDir"
Write-Verbose "Resource file: $weuResourceFile"
Write-Verbose "`n"

## Load resources from file to script
$weuResourceJson = Get-Content $weuResourceFile | ConvertFrom-Json
$weuResourceTable = @{} # To be populated by the below line
$weuResourceJson.PSObject.Properties | ForEach-Object { $weuResourceTable[$_.Name] = $_.Value }
Write-Verbose "$($weuResourceTable.Count) package(s) found from the resource file"
Write-Verbose "`n"

## Wait until the user selects the specified package group
##
## In this part, we let the user select what package group to install
## without making their machine filled with unnecessary packages
"Choose a package group to install:"
"   1) Media Foundation Codecs"
"   2) Development apps (coming soon!)"
""
"* Press the number to install the selected group"
"* Press ESC to abort & exit the installation"
""

# Interaction state (if no longer needed, set to $false)
$weuSelectedInteraction = $True
# Available string values: "MediaFoundationCodecs"
$weuSelectedPackageGroup = $Null

While ($weuSelectedInteraction) {
    $key = [System.Console]::ReadKey($True)

    Switch ($key.Key) {
        "D1" {
            "-> Installing Media Foundation Codecs ..."
            $weuSelectedPackageGroup = "MediaFoundationCodec"
            $weuSelectedInteraction = $False
        }
        "Escape" {
            "-> Aborting the current operation, bye!"
            Exit 1
        }
    }
}

## Download the packages from the selected group
$weuPackageGroup = $weuSelectedPackageGroup
$weuPackageTable = @{} # To be populated by the below code

# Populate $weuResourceTable, which only contains the group's packages
$weuResourceTable.Keys | ForEach-Object {
    if ($weuResourceTable[$_].Group -Eq $weuPackageGroup) {
        # Only add package if it's a part of the selected group
        $weuPackageTable.Add($_, $weuResourceTable[$_])
    }
}
# Initiate the download-and-install procedure for each package
$weuPackageTable.Keys | ForEach-Object {
    $package = $weuPackageTable[$_]
    $packageDownloadLink = $package.DownloadLink
    $packageFilename = $package.LocalFilename
    $packageOutFile = Join-Path $weuInstallDir $packageFilename

    # Download the package using Invoke-WebRequest
    If (-Not (Test-Path $packageOutFile -PathType Leaf)) {
        Try {
            "Downloading $_"
            Invoke-WebRequest -Uri $packageDownloadLink -OutFile $packageOutFile
        }
        Catch [System.Net.WebException] {
            $message = $_.Exception.Message
            Write-Error "An error occurred while downloading $($packageFilename): $message"
            Break
        }
    }
    # Install the package using the built-in Appx module
    If ([boolean]((Get-AppxPackage).Name -Match $_)) {
        Write-Warning "$_ is already installed for current user, skipping"
        Return
    }
    
    "Installing $_ for current user"
    Add-AppxPackage $packageOutFile
}

"`n"
"Done!"
