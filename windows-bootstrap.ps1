#!/usr/bin/env Windows PowerShell

[Security.Principal.WindowsPrincipal]$CurrentPrincipal = [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not($CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Output "It must be run as administrator!"
    exit
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

if (-not (Get-Command choco -ea SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if (-not (Get-Command git -ea SilentlyContinue)) {
    choco install git.install --yes --params="'/NoShellIntegration /NoAutoCrlf'"
}

if (!(Test-Path $HOME\.dotfiles)) {
    git clone https://github.com/neko3cs/.dotfiles.git
    Set-Location .dotfiles
}

. .\Set-PwshProfile.ps1
. .\Set-VimConfigs.ps1
. .\Set-WindowsOptionalFeature.ps1
. .\Install-SQLServerManagementStudio.ps1

# 以下のスクリプトはオプション指定が必要なため手動で入れる
# - Install-ChocolateyApps.ps1
# - Install-VisualStudio.ps1
