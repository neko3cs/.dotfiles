#!/usr/bin/env pwsh

if (Test-Path $PROFILE) {
	Remove-Item `
		-Path $PROFILE `
		-Force
}

# Can not 'New-Item -ItemType SymbolicLink'; it's specified file, so copy this.
New-Item `
	-ItemType File `
	-Path $PROFILE `
	-Force
Copy-Item `
	-Path .\Microsoft.PowerShell_profile.ps1 `
	-Destination $PROFILE `
	-Force
