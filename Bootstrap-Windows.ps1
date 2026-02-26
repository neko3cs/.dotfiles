#Requires -RunAsAdministrator
#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Set-Wsl2Fedora {
  wsl --install --no-launch --distribution FedoraLinux-43
  wsl --set-default FedoraLinux-43
  wsl --set-default-version 2
}

try {
  Get-Command winget -ErrorAction Stop | Out-Null
}
catch {
  Write-Error 'winget is not installed. Please install it from Microsoft Store.'
}

try {
  Get-Command git -ErrorAction Stop | Out-Null
}
catch {
  Write-Error "git is not installed. Install it with:`nwinget install --silent --exact --id Git.Git"
}

Set-Location -Path $HOME
$dotfilesPath = Join-Path $HOME '.dotfiles'
if (-not (Test-Path $dotfilesPath)) {
  git clone https://github.com/neko3cs/.dotfiles.git $dotfilesPath
}
Set-Location -Path $dotfilesPath

& (Join-Path $PSScriptRoot 'Enable-WindowsOptionalFeature.ps1')
& (Join-Path $PSScriptRoot 'Install-WingetPackage.ps1')
& (Join-Path $PSScriptRoot 'Install-PnpmPackage.ps1')
& (Join-Path $PSScriptRoot 'Set-DotFiles.ps1')
& (Join-Path $PSScriptRoot 'Set-Completions.ps1')
Set-Wsl2Fedora

if (Test-Path $PROFILE) {
  . $PROFILE
}
