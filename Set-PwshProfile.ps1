#!/usr/bin/env pwsh

if (Test-Path $PROFILE) {
    Remove-Item -Force $PROFILE
}

# Can not 'New-Item -ItemType SymbolicLink'; it's specified file, so copy this.
New-Item -ItemType File -Path $PROFILE -Force
Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE -Force
