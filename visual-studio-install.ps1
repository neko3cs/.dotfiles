#!pwsh

param(
    [ValidateSet("Community", "Professional", "Enterprise")]
    [string]$Edition = "Community"
)

[string]$vsInstallerName;
switch ($Edition) {
    "Community" { $vsInstallerName = "vs_community.exe"; }
    "Professional" { $vsInstallerName = "vs_professional.exe"; }
    "Enterprise" { $vsInstallerName = "vs_enterprise.exe"; }
}

$vswherePath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe";
if (!(& $vswherePath -ErrorAction SilentlyContinue)) {
    Write-Host `
        "Install Visual Studio ${Edition}...`n" `
        -ForegroundColor Green
    Invoke-WebRequest `
        -Uri http://aka.ms/vs/16/release/$vsInstallerName `
        -UseBasicParsing `
        -OutFile $vsInstallerName
    Start-Process `
        -FilePath $vsInstallerName `
        -ArgumentList "--config `"${PWD}\.vsconfig`" --passive --norestart --wait" `
        -Verb runas `
        -Wait
    Remove-Item `
        -Path $vsInstallerName
}
else {
    Write-Host `
        "Update Visual Studio ${Edition}...`n" `
        -ForegroundColor Green
    Invoke-WebRequest `
        -Uri http://aka.ms/vs/16/release/$vsInstallerName `
        -UseBasicParsing `
        -OutFile $vsInstallerName
    Start-Process `
        -FilePath $vsInstallerName `
        -ArgumentList "update --passive --norestart --wait" `
        -Verb runas `
        -Wait
    Remove-Item `
        -Path $vsInstallerName
}
