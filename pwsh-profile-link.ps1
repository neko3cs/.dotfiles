# Windows Powershell

if (Test-Path $PROFILE) {
    Remove-Item -Force $PROFILE
}

# Can not 'New-Item -ItemType SymbolicLink'; it's specified file, so copy this.
Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE
