#!pwsh

param(
    [switch]$Force
)

$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -eq 'RemoteSigned') {
    Set-ExecutionPolicy RemoteSigned
}

if (!(Get-Command choco -ea SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if ($Force) {
    choco install chocolatey-package.config --force --yes
}
else {
    choco install chocolatey-package.config --yes
}
