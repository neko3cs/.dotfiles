# Windows PowerShell

$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -eq 'RemoteSigned') {
    Set-ExecutionPolicy RemoteSigned
}

Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install chocolatey-package.config -y
