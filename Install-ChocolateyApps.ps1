#!pwsh

param(
    [switch]$Force,
    [ValidateSet("Private", "Work")]
    [string]$UseFor = "Private"
)

if (!(Get-Command choco -ea SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if ($Force) {
    choco install .\ChocolateyPackage.config --force --yes
}
else {
    choco install .\ChocolateyPackage.config --yes
}

if ($UseFor -eq "Private") {
    if ($Force) {
        choco install .\ChocolateyPackageForPrivate.config --force --yes
    }
    else {
        choco install .\ChocolateyPackageForPrivate.config --yes
    }
}
elseif ($UseFor -eq "Work") {
    if ($Force) {
        choco install .\ChocolateyPackageForWork.config --force --yes
    }
    else {
        choco install .\ChocolateyPackageForWork.config --yes
    }
}
