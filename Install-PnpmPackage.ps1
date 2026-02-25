$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PackagesFile = Join-Path $ScriptDir "npm-packages.txt"

if (-not (Get-Command corepack -ErrorAction SilentlyContinue)) {
  Write-Host "corepack not found. Installing corepack via npm..."
  npm install -g corepack
}
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
  Write-Host "pnpm not found or not enabled. Enabling pnpm via corepack..."
  corepack use pnpm@latest
}

if (Test-Path $PackagesFile) {
  Get-Content $PackagesFile | ForEach-Object {
    $package = $_.Trim()
    if ([string]::IsNullOrWhiteSpace($package) -or $package.StartsWith("#")) {
      return
    }
    pnpm add -g $package
  }
}
else {
  Write-Host "Error: $PackagesFile not found."
  exit 1
}
