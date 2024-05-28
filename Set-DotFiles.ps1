#Requires -RunAsAdministrator

if ($IsWindows) {
  New-Item -ItemType File -Force -Path $PROFILE | Out-Null
  Copy-Item -Force -Path $PWD\config\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Value $PWD/config/.gitconfig | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.starship/starship.toml -Value $PWD/config/starship.toml | Out-Null
}
elseif ($IsMacOS) {
  Copy-Item -Force -Path ./config/Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
}
