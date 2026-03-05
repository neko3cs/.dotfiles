#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$completionDir = "$HOME/.config/powershell/completions"
if (-not (Test-Path -Path $completionDir)) {
  New-Item -ItemType Directory -Path $completionDir -Force | Out-Null
}

if (Get-Command -Name deno -ErrorAction SilentlyContinue) {
  deno completions powershell | Out-File -FilePath (Join-Path $completionDir "_deno.ps1") -Encoding UTF8
}
if (Get-Command -Name docker -ErrorAction SilentlyContinue) {
  docker completion powershell | Out-File -FilePath (Join-Path $completionDir "_docker.ps1") -Encoding UTF8
}
if (Get-Command -Name dotnet -ErrorAction SilentlyContinue) {
  dotnet completions script pwsh  | Out-File -FilePath (Join-Path $completionDir "_dotnet.ps1") -Encoding UTF8
}
if (Get-Command -Name gh -ErrorAction SilentlyContinue) {
  gh completion -s powershell | Out-File -FilePath (Join-Path $completionDir "_gh.ps1") -Encoding UTF8
}
if (Get-Command -Name pip -ErrorAction SilentlyContinue) {
  pip completion --powershell | Out-File -FilePath (Join-Path $completionDir "_pip.ps1") -Encoding UTF8
}
if (Get-Command -Name starship -ErrorAction SilentlyContinue) {
  starship completions powershell | Out-File -FilePath (Join-Path $completionDir "_starship.ps1") -Encoding UTF8
}
