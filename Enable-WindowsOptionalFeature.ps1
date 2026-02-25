#Requires -RunAsAdministrator
#Requires -Version 7.0
#Requires -Module Dism
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$OptionalFeatures = @(
  "Microsoft-Hyper-V-All"
  "Microsoft-Windows-Subsystem-Linux"
  "VirtualMachinePlatform"
)

$RebootRequired = $false
foreach ($Feature in $OptionalFeatures) {
  $info = Get-WindowsOptionalFeature `
    -Online `
    -FeatureName $Feature

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
      Enable-WindowsOptionalFeature `
        -Online `
        -FeatureName $Feature `
        -NoRestart
      $RebootRequired = $true
      Write-Host "'$Feature' has been enabled."
    }
  }
}

if ($RebootRequired) {
  Write-Output "Please restart OS..."
}
