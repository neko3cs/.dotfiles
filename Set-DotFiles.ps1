#Requires -RunAsAdministrator
#Requires -Version 7.0
Set-StrictMode -Version Latest

if ($IsWindows) {
  New-Item -ItemType File -Force -Path $PROFILE | Out-Null
  Copy-Item -Force -Path $PSScriptRoot\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Value $PSScriptRoot\.gitconfig | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.starship/starship.toml -Value $PSScriptRoot\starship.toml | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.config/bat/config -Value $PSScriptRoot\bat_config | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.textlintrc.json -Value $PSScriptRoot\.textlintrc.json | Out-Null
}
elseif ($IsMacOS) {
  Copy-Item -Force -Path $PSScriptRoot\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
}
