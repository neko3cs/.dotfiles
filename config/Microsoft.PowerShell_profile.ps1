#Requires -PSEdition Core

$PwshCompletionsDir = "$HOME/.dotfiles/config/pwsh_completions"
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
  . $PwshCompletionsDir/Register-WingetCompletion.ps1
  # Env
  $Env:JAVA_HOME = "$HOME\AppData\Local\Programs\Microsoft\jdk-17.0.10.7-hotspot"
  $Env:ANDROID_HOME = "$HOME\AppData\Local\Android\Sdk"
  $Env:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
  $Env:STARSHIP_CACHE = "$HOME\.starship\cache"
  $Env:AWS_DEFAULT_PROFILE = "default"
  $paths = @(
    "$($Env:LOCALAPPDATA)\DotNetVersions"
    "$($Env:LOCALAPPDATA)\ProcessExplorer"
    "$($Env:LOCALAPPDATA)\ULE4JIS"
  )
  $Env:Path = ([string]::Join(";", $paths) + ";" + $Env:Path)
  # Alias
  Set-Alias -Name open -Value 'explorer.exe'
  Set-Alias -Name lg -Value 'lazygit.exe'
  Set-Alias -Name jq -Value 'jq-win64.exe'
  Set-Alias -Name winmerge -Value "$HOME\AppData\Local\Programs\WinMerge\WinMergeU.exe"
  Set-Alias -Name docker -Value "podman"
  function zsh { wsl /usr/bin/zsh }
  function which {
    param([Parameter(Mandatory, ValueFromPipeline)][string]$command)
    return (Get-Command -Name $command -ShowCommandInfo).Definition
  }
  function ConvertTo-WslPath {
    param([Parameter(Mandatory, ValueFromPipeline)][string]$Path)
    return wsl --exec wslpath $Path
  }
  function nano {
    param([string]$Path)
    if ([string]::IsNullOrEmpty($Path)) { 
      wsl --exec nano
    }
    else {
      $WslPath = ConvertTo-WslPath -Path $Path
      wsl --exec nano $WslPath
    }
  }
  function vim {
    param ([string]$Path)
    if ([string]::IsNullOrEmpty($Path)) { 
      wsl vim
    }
    else {
      $WslPath = ConvertTo-WslPath -Path $Path
      wsl vim $WslPath
    }
  }
  function less {
    param ([Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$Path)
    $WslPath = ConvertTo-WslPath -Path $Path
    wsl less $WslPath
  }
  function refreshenv {
    try {
      $systemEnv = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -ErrorAction Stop
      $userEnv = Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -ErrorAction Stop
    }
    catch {
      Write-Error "Can not load env from registory.: $_"
      return
    }

    foreach ($prop in $systemEnv.PSObject.Properties) {
      if ($prop.Name -like "PS*") { continue }
      if ($prop.Name -eq "Path") { continue }
      ${env:$($prop.Name)} = $prop.Value
    }
    foreach ($prop in $userEnv.PSObject.Properties) {
      if ($prop.Name -like "PS*") { continue }
      if ($prop.Name -eq "Path") { continue }
      ${env:$($prop.Name)} = $prop.Value
    }

    $systemPath = $systemEnv.Path
    $userPath = $userEnv.Path

    if ($systemPath -and $userPath) {
      $env:Path = "$systemPath;$userPath"
    }
    elseif ($systemPath) {
      $env:Path = $systemPath
    }
    elseif ($userPath) {
      $env:Path = $userPath
    }
    else {
      $env:Path = ""
    }
  }
}
elseif ($IsMacOS) {
  # Prompt Design
  Invoke-Expression (& '/usr/local/bin/starship' init powershell --print-full-init | Out-String)
  # Alias
  Set-Alias -Name lg -Value 'lazygit'
}
# Import Module
Register-PowerShellModule
# Completion
starship completions powershell | Out-String | Invoke-Expression
podman completion powershell | Out-String | Invoke-Expression
pip completion --powershell | Out-String | Invoke-Expression
. $PwshCompletionsDir/Register-DotNetCompletion.ps1
. $PwshCompletionsDir/Register-AzureCliCompletion.ps1
. $PwshCompletionsDir/Register-AwsCliCompletion.ps1
. $PwshCompletionsDir/Register-SqlcmdCompletion.ps1
# PowerShell Options
Set-PSReadLineOption `
  -PredictionSource History `
  -PredictionViewStyle InlineView `
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
