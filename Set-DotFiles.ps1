#!/usr/bin/env pwsh

if (Test-Path $PROFILE) {
  Remove-Item `
    -Path $PROFILE `
    -Force
}
if (Test-Path -Path $HOME/.vimrc) {
  Remove-Item `
    -Path $HOME/.vimrc `
    -Force
}

Copy-Item `
  -Path .\Microsoft.PowerShell_profile.ps1 `
  -Destination $PROFILE `
  -Force
Copy-Item `
  -Path $HOME\.dotfiles\.vimrc `
  -Destination $HOME\.vimrc `
  -Force
