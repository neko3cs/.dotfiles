#!pwsh

param(
    [switch]$Force,
    [switch]$Private
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

if ($Private -and $Force) {
    choco install .\ChocolateyPackageForPrivate.config --force --yes
}
elseif ($Private) {
    choco install .\ChocolateyPackageForPrivate.config --yes
}
