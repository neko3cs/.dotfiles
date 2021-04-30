# Windows PowerShell

# Oh-My-Posh
if (!(Get-Command Get-PoshThemes -ea SilentlyContinue)) {
    Install-Module -Name oh-my-posh -AllowPrerelease -Force
}
# Git-Posh
if (!(Get-Command Get-GitStatus -ea SilentlyContinue)) {
    Install-Module -Name posh-git
}
# SQLServer
if (!(Get-Command Get-SqlCmd -ea SilentlyContinue)) {
    Install-Module -Name sqlserver
}
# ImportExcel
if (!(Get-Command Import-Excel -ea SilentlyContinue)) {
    Install-Module -Name ImportExcel
}
