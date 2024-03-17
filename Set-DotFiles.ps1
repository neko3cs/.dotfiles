#Requires -RunAsAdministrator

function Set-PSProfile {
  if (Test-Path $PROFILE) {
    Remove-Item `
      -Path $PROFILE `
      -Force
  }
  Copy-Item `
    -Path $PWD\config\Microsoft.PowerShell_profile.ps1 `
    -Destination $PROFILE `
    -Force
}

if ($IsWindows) {
  $dotfiles = @(
    ".gitconfig"
  )

  Set-PSProfile

  foreach ($dotfile in $dotfiles) {
    if (Test-Path -Path $HOME/$dotfile) {
      Remove-Item `
        -Path $HOME/$dotfile `
        -Force
    }
    New-Item `
      -ItemType SymbolicLink `
      -Path $HOME/$dotfile `
      -Value $PWD/config/$dotfile `
      -Force
  }
}
