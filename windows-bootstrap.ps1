#Requires -RunAsAdministrator

function Set-Wsl2Ubuntu {
  wsl --install --no-launch --distribution Ubuntu
  wsl --set-default Ubuntu
  wsl --set-default-version 2
}

if (!(Get-Command winget -ea SilentlyContinue)) {
  Write-Host `
    "Error: winget has not installed! Please install from Microsoft Store." `
    -ForegroundColor Red
  exit
}
if (!(Get-Command git -ea SilentlyContinue)) {
  Write-Host `
    "Error: git has not installed! Please install it in the following this:`r`nPS1> winget install --silent --exact --id Git.Git" `
    -ForegroundColor Red
  exit
}
while ($true) {
  $useFor = Read-Host "Private? Work?"
  if (@("Private", "Work").Contains($useFor)) {
    break;
  }
}

Set-Location $HOME
if (!(Test-Path $HOME\.dotfiles)) {
  git clone https://github.com/neko3cs/.dotfiles.git
}
Set-Location -Path .dotfiles

& .\Enable-WindowsOptionalFeature.ps1
Set-Wsl2Ubuntu
& .\Install-WingetPackage.ps1 -UseFor $useFor
pwsh -Command { & .\Set-DotFiles.ps1 }
