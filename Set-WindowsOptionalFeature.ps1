#!pwsh

$OptionalFeatures = @(
  "Microsoft-Hyper-V-All"
  "Microsoft-Windows-Subsystem-Linux"
  "IIS-WebServerRole"
)

foreach ($Feature in $OptionalFeatures) {
  $State = (Get-WindowsOptionalFeature -Online -FeatureName $Feature).State
  if ($State -eq "Enabled") {
    Write-Output "'$($Feature)' has already enabled."
    continue
  }

  Enable-WindowsOptionalFeature -Online -FeatureName $Feature
  Write-Output "'$($Feature)' is now enabled."
}
