#!/usr/bin/env pwsh

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

if (!(Get-Command winget -ea SilentlyContinue)) {
    Write-Host `
        "Error: winget has not installed! please install from Microsoft Store." `
        -ForegroundColor Red
    exit
}

Get-ChildItem .\winget-package*.yaml |
ForEach-Object {
    Get-Content $_.FullName |
    ConvertFrom-Yaml |
    ConvertTo-Json -Depth 4 |
    Out-File ($_.FullName -replace ".yaml", ".json")
}

winget import `
    --import-file .\winget-package.json `
    --ignore-unavailable `
    --accept-package-agreements `
    --accept-source-agreements

if ($UseFor -eq "Private") {
    winget import `
        --import-file .\winget-package.private.json `
        --ignore-unavailable `
        --accept-package-agreements `
        --accept-source-agreements
}
elseif ($UseFor -eq "Work") {
    winget import `
        --import-file .\winget-package.work.json `
        --ignore-unavailable `
        --accept-package-agreements `
        --accept-source-agreements
}

Get-ChildItem .\winget-package*.json |
Remove-Item
