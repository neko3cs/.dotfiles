#!pwsh

param(
    [switch]$Force,
    [switch]$Private
)

if (!(Get-Command choco -ea SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if ($Force) {
    choco install chocolatey-package.config --force --yes
}
else {
    choco install chocolatey-package.config --yes
}

if ($Private -and $Force) {
    choco install chocolatey-package.private.config --force --yes
}
elseif ($Private) {
    choco install chocolatey-package.private.config --yes
}
