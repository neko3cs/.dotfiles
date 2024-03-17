#Requires -RunAsAdministrator

param(
    [ValidateSet("Private", "Work")]
    [string]$UseFor
)

if ([string]::IsNullOrEmpty($UseFor)) {
    Write-Host `
        "Error: UseFor option is required!" `
        -ForegroundColor Red
    exit
}
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

Get-ChildItem .\config\winget-package*.yaml |
ForEach-Object {
    Get-Content $_.FullName |
    ConvertFrom-Yaml |
    ConvertTo-Json -Depth 4 |
    Out-File (Join-Path $PWD ($_.Name -replace ".yaml", ".json"))
}

winget import `
    --import-file $PWD\winget-package.json `
    --ignore-unavailable `
    --accept-package-agreements `
    --accept-source-agreements

if ($UseFor -eq "Private") {
    winget import `
        --import-file $PWD\winget-package.private.json `
        --ignore-unavailable `
        --accept-package-agreements `
        --accept-source-agreements
}
elseif ($UseFor -eq "Work") {
    winget import `
        --import-file $PWD\winget-package.work.json `
        --ignore-unavailable `
        --accept-package-agreements `
        --accept-source-agreements
}

Get-ChildItem $PWD\winget-package*.json |
Remove-Item
