#Requires -RunAsAdministrator

if (!(Get-Command winget -ea SilentlyContinue)) {
    Write-Host `
        "Error: winget has not installed! please install from Microsoft Store." `
        -ForegroundColor Red
    exit
}
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml
}
if (-not (Get-Module -Name powershell-yaml)) {
    Import-Module -Name powershell-yaml
}

Get-Content .\config\winget-package.yaml |
ConvertFrom-Yaml |
ConvertTo-Json -Depth 4 |
Out-File (Join-Path $PWD winget-package.json)

winget import `
    --import-file $PWD\winget-package.json `
    --ignore-unavailable `
    --accept-package-agreements `
    --accept-source-agreements

Get-ChildItem $PWD\winget-package.json |
Remove-Item
