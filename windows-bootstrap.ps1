#Requires -RunAsAdministrator

function Set-Wsl2Ubuntu {
  wsl --install --no-launch --distribution Ubuntu
  wsl --set-default Ubuntu
  wsl --set-default-version 2
}

if (!(Get-Command winget -ea SilentlyContinue)) {
  Write-Host `
    "Error: winget has not installed! please install from Microsoft Store." `
    -ForegroundColor Red
  exit
}
while ($true) {
  $useFor = Read-Host "Private? Work?"
  if (@("Private", "Work").Contains($useFor)) {
    break;
  }
}
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
winget install --silent --exact --id Git.Git

Invoke-Command -ScriptBlock {
  Set-Location $HOME
  if (!(Test-Path $HOME\.dotfiles)) {
    git clone https://github.com/neko3cs/.dotfiles.git
  }
  Set-Location -Path .dotfiles

  & .\Enable-WindowsOptionalFeature.ps1
  Set-Wsl2Ubuntu
  & .\Install-WingetPackage.ps1 -UseFor $useFor
  pwsh -Command { & .\Set-DotFiles.ps1 }
}
