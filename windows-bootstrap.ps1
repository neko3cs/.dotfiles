#!Windows PowerShell

function Set-ChocolateyApps {
  if (!(Get-Command choco -ea SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }
  choco install .\ChocolateyPackage.config --yes
}

function Set-Wsl2Ubuntu {
  wsl --install --distribution Ubuntu
  wsl --set-default Ubuntu
  wsl --set-default-version 2
}

[Security.Principal.WindowsPrincipal]$CurrentPrincipal = [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not($CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
  Write-Output "It must be run as administrator!"
  exit
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

winget install --id Git.Git --exact --silent

if (!(Test-Path $HOME\.dotfiles)) {
  git clone https://github.com/neko3cs/.dotfiles.git
  Set-Location -Path .dotfiles
}

. .\Set-DotFiles.ps1
Set-ChocolateyApps
Set-Wsl2Ubuntu
. .\Set-WindowsOptionalFeature.ps1

Write-Output @"
Please run this script...
- Install-WingetPackage.ps1 -UseFor (Private|Work)
"@
