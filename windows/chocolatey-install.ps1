# Windows PowerShell

Param (
    [ValidateScript( { [Enum]::GetValues([UseFor]) -contains $_ })]
    [string]$UseFor
)

enum UseFor {
    Private
    Work
}

$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -eq 'RemoteSigned') {
    Set-ExecutionPolicy RemoteSigned
}

if (!(Get-Command choco -ea SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco install chocolatey-package.config -y

switch ($UseFor) {
    UseFor.Private { 
        choco install chocolatey-package-private.config -y
    }
    UseFor.Work {
        choco install chocolatey-package-work.config -y
    }
    Default {
        choco install chocolatey-package-private.config -y
    }
}
