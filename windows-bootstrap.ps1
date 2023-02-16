# Windows PowerShell
#Requires -Version 5.1
#Requires -RunAsAdministrator

function Set-Wsl2Ubuntu {
  wsl --install --distribution Ubuntu
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

winget install --id Git.Git --exact --silent

# 別セッションで実行することでGitのパスが通った状態で実行する
Invoke-Command -NoNewScope -ScriptBlock {
  if (!(Test-Path $HOME\.dotfiles)) {
    git clone https://github.com/neko3cs/.dotfiles.git
    Set-Location -Path .dotfiles
  }
  
  . .\Set-DotFiles.ps1
  . .\Set-WindowsOptionalFeature.ps1
  Set-Wsl2Ubuntu
  . .\Install-WingetPackage.ps1 -UseFor $useFor  
}
