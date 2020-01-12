# Windows Powershell

Param (
    [Parameter(Mandatory)]
    [string]$ProfilePath
)

if (Test-Path $ProfilePath) {
    Remove-Item -Force $ProfilePath
}

# Can not 'New-Item -ItemType SymbolicLink'; it's specified file, so copy this.
Copy-Item .\Microsoft.PowerShell_profile.ps1 $ProfilePath
