#!pwsh

Invoke-WebRequest `
    -UseBasicParsing `
    -Headers $Headers `
    -Uri https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe `
    -OutFile "Docker Desktop Installer.exe"
Start-Process `
    -FilePath "Docker Desktop Installer.exe" `
    -Verb runas `
    -Wait
Remove-Item `
    -Path "Docker Desktop Installer.exe"
