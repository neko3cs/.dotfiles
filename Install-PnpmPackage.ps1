#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$PackagesFile = Join-Path $PSScriptRoot 'npm-packages.txt'

try {
  Get-Command corepack -ErrorAction Stop | Out-Null
}
catch {
  Write-Host 'corepack not found. Installing via npm...'
  npm install -g corepack
  if ($LASTEXITCODE -ne 0) {
    throw 'Failed to install corepack.'
  }
}
try {
  Get-Command pnpm -ErrorAction Stop | Out-Null
}
catch {
  Write-Host 'pnpm not found or not enabled. Enabling via corepack...'
  corepack use pnpm@latest
  if ($LASTEXITCODE -ne 0) {
    throw 'Failed to enable pnpm.'
  }
}

if (-not (Test-Path $PackagesFile)) {
  throw "Package list not found: $PackagesFile"
}
Get-Content $PackagesFile | ForEach-Object {
  $package = $_.Trim()
  if ([string]::IsNullOrWhiteSpace($package) -or $package.StartsWith('#')) {
    return
  }
  pnpm add -g $package
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to install package: $package"
  }
}
