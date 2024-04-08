#Requires -RunAsAdministrator

$OptionalFeatures = @(
  "Microsoft-Hyper-V-All"
  "Microsoft-Windows-Subsystem-Linux"
  "VirtualMachinePlatform"
)

$EnabledFeature = $false
foreach ($Feature in $OptionalFeatures) {
  $State = 
  Get-WindowsOptionalFeature `
    -Online `
    -FeatureName $Feature |
  Select-Object `
    -ExpandProperty State

  if ($State -eq "Enabled") {
    Write-Output "'$($Feature)' has already enabled."
    continue
  }

  Enable-WindowsOptionalFeature `
    -Online `
    -FeatureName $Feature `
    -NoRestart
  Write-Output "'$($Feature)' is now enabled."
  $EnabledFeature = $true
}

if ($EnabledFeature) {
  Write-Output "Please restart OS..."
}
