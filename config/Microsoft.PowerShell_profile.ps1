#Requires -PSEdition Core

$DotfilesConfigDir = "$HOME/.dotfiles/config"
$PowerShellModules = @(
  "posh-git"
  "Pester"
  "powershell-yaml"
  "SqlServer"
  "ClassExplorer"
  "ImportExcel"
)
function Register-PowerShellModule {
  foreach ($module in $PowerShellModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
      Install-Module -Name $module
    }
    if (-not (Get-Module -Name $module)) {
      Import-Module -Name $module
    }
  }
}

if ($IsWindows) {
  # Prompt Design
  Invoke-Expression (&starship init powershell)
  # Completion
  . $DotfilesConfigDir/Register-WingetCompletion.ps1
  # Env
  $Env:JAVA_HOME = "$HOME\AppData\Local\Programs\Microsoft\jdk-17.0.10.7-hotspot"
  $Env:ANDROID_HOME = "$HOME\AppData\Local\Android\Sdk"
  $Env:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
  $Env:STARSHIP_CACHE = "$HOME\.starship\cache"
  $Env:AWS_DEFAULT_PROFILE = "default"
  # Alias
  Set-Alias -Name open -Value 'explorer.exe'
  Set-Alias -Name lg -Value 'lazygit.exe'
  Set-Alias -Name ads -Value 'azuredatastudio.cmd'
  Set-Alias -Name jq -Value 'jq-win64.exe'
  Set-Alias -Name winmerge -Value "$HOME\AppData\Local\Programs\WinMerge\WinMergeU.exe"
  function zsh { wsl /usr/bin/zsh }
  function which {
    param([Parameter(Mandatory, ValueFromPipeline)][string]$command)
    return (Get-Command -Name $command -ShowCommandInfo).Definition
  }
}
elseif ($IsMacOS) {
  # Prompt Design
  Invoke-Expression (& '/usr/local/bin/starship' init powershell --print-full-init | Out-String)
  # Alias
  Set-Alias -Name lg -Value 'lazygit'
  Set-Alias -Name ads -Value 'azuredatastudio'
}

# Completion
Register-PowerShellModule
. $DotfilesConfigDir/Register-StarshipCompletion.ps1
. $DotfilesConfigDir/Register-DenoCompletion.ps1
. $DotfilesConfigDir/Register-DotNetCompletion.ps1
. $DotfilesConfigDir/Register-PipCompletion.ps1
. $DotfilesConfigDir/Register-AzureCliCompletion.ps1
. $DotfilesConfigDir/Register-SqlcmdCompletion.ps1
# PowerShell Options
Set-PSReadLineOption `
  -PredictionSource History `
  -PredictionViewStyle ListView `
  -MaximumHistoryCount 200 `
  -HistorySearchCaseSensitive `
  -HistorySearchCursorMovesToEnd `
  -HistoryNoDuplicates `
  -BellStyle Visual
[Console]::OutputEncoding = [Text.Encoding]::UTF8
# Alias
Set-Alias -Name touch -Value New-Item
Set-Alias -Name ll -Value Get-ChildItem
function la { param($Path = ".") Get-ChildItem -Path $Path -Force }
function lla { param($Path = ".") Get-ChildItem -Path $Path -Force }
