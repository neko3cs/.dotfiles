#Requires -RunAsAdministrator

if ($IsWindows) {
  New-Item -ItemType File -Force -Path $PROFILE | Out-Null
  Copy-Item -Force -Path $PWD\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Value $PWD\.gitconfig | Out-Null
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.starship/starship.toml -Value $PWD\starship.toml | Out-Null
}
elseif ($IsMacOS) {
  Copy-Item -Force -Path ./Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
}
