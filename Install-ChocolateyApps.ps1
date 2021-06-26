#!pwsh

param(
    [switch]$Force,
    [ValidateSet("Private", "Work")]
    [string]$UseFor
)

if ([string]::IsNullOrEmpty($UseFor)) {
    Write-Host `
        "Error: UseFor option is required!" `
        -ForegroundColor Red
    exit
}

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
        choco install .\ChocolateyPackage.Private.config --force --yes
    }
    else {
        choco install .\ChocolateyPackage.Private.config --yes
    }
}
elseif ($UseFor -eq "Work") {
    if ($Force) {
        choco install .\ChocolateyPackage.Work.config --force --yes
    }
    else {
        choco install .\ChocolateyPackage.Work.config --yes
    }
}
