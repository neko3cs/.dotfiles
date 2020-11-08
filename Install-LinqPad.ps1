#!pwsh

$Url = "https://www.linqpad.net/GetFile.aspx?LINQPad6Setup.exe"
$InstallerName = "LINQPad6Setup.exe"
$Arguments = "/VERYSILENT /NORESTART"

Invoke-WebRequest `
    -Uri $Url `
    -UseBasicParsing `
    -OutFile $InstallerName
Start-Process `
    -FilePath $InstallerName `
    -ArgumentList $Arguments `
    -Verb runas `
    -Wait
Remove-Item `
    -Path $InstallerName
