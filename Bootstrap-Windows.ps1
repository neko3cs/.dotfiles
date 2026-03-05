#Requires -RunAsAdministrator
#Requires -Version 7.0
#Requires -Module Dism
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Set-Wsl2Fedora {
  wsl --install --no-launch --distribution FedoraLinux-43
  wsl --set-default FedoraLinux-43
  wsl --set-default-version 2
}
function Enable-WindowsOptionalFeature {
  $OptionalFeatures = @(
    "Microsoft-Hyper-V-All"
    "Microsoft-Windows-Subsystem-Linux"
    "VirtualMachinePlatform"
  )
  $RebootRequired = $false
  foreach ($Feature in $OptionalFeatures) {
    $info = Get-WindowsOptionalFeature -Online -FeatureName $Feature
    if ($null -eq $info) {
      Write-Warning "Feature '$Feature' was not found."
      continue
    }
    switch ($info.State) {
      'Enabled' {
        Write-Host "'$Feature' is already enabled."
      }
      'EnablePending' {
        Write-Host "'$Feature' is pending enable. Reboot required."
        $RebootRequired = $true
      }
      default {
        Write-Host "Enabling '$Feature'..."
        Enable-WindowsOptionalFeature -Online -FeatureName $Feature -NoRestart
        $RebootRequired = $true
        Write-Host "'$Feature' has been enabled."
      }
    }
  }
  if ($RebootRequired) {
    Write-Output "Please restart OS..."
  }
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

. (Join-Path $PSScriptRoot 'Install-WingetPackage.ps1')
. (Join-Path $PSScriptRoot 'Install-PnpmPackage.ps1')
. (Join-Path $PSScriptRoot 'Set-DotFiles.ps1')
. (Join-Path $PSScriptRoot 'Set-Completions.ps1')
Set-Wsl2Fedora
Enable-WindowsOptionalFeature

if (Test-Path $PROFILE) {
  . $PROFILE
}
