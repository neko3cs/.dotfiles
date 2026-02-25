#Requires -RunAsAdministrator
#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
  Get-Command winget -ErrorAction Stop | Out-Null
}
catch {
  throw 'winget is not installed. Install it from Microsoft Store.'
}
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
  Write-Host 'Installing powershell-yaml module...'
  Install-Module powershell-yaml -Scope CurrentUser -Force
}
Import-Module powershell-yaml -ErrorAction Stop

$packageFilePath = Join-Path $PSScriptRoot 'winget-package.yaml'
if (-not (Test-Path $packageFilePath)) {
  throw "YAML file not found: $packageFilePath"
}

$packages = Get-Content -Path $packageFilePath -Raw | ConvertFrom-Yaml
foreach ($package in $packages) {
  if ($null -ne $package.Options) {
    winget install `
      --id $package.Id `
      --override $package.Options `
      --silent `
      --accept-package-agreements `
      --accept-source-agreements
  }
  else {
    winget install `
      --id $package.Id `
      --silent `
      --accept-package-agreements `
      --accept-source-agreements
  }
}
