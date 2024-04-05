#Requires -RunAsAdministrator

if ($IsWindows) {
  New-Item -ItemType File -Force -Path $PROFILE
  Copy-Item -Force -Path $PWD\config\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Value $PWD/config/.gitconfig
  New-Item -ItemType SymbolicLink -Force -Path $HOME/.starship/starship.toml -Value $PWD/config/starship.toml
}
elseif ($IsMacOS) {
  Copy-Item -Force -Path ./config/Microsoft.PowerShell_profile.ps1 -Destination $PROFILE
}
