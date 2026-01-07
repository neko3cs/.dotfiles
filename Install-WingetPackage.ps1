#Requires -RunAsAdministrator

if (!(Get-Command winget -ea SilentlyContinue)) {
    Write-Host `
        "Error: winget has not installed! please install from Microsoft Store." `
        -ForegroundColor Red
    exit
}
if (-not (Get-Module -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml
    Import-Module -Name powershell-yaml
}

$packages = Get-Content -Path .\winget-package.yaml | ConvertFrom-Yaml
foreach ($package in $packages) {
    if ($null -ne $packages.Options) {
        Write-Output "Install $($package.Id) with options: '$($package.Options)'"
        winget install --id $package.Id --override $package.Options `
            --silent --accept-package-agreements --accept-source-agreements
    }
    else {
        Write-Output "Install $($package.Id)"
        winget install --id $package.Id `
            --silent --accept-package-agreements --accept-source-agreements
    }
}
