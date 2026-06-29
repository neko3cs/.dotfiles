#Requires -Version 7.0
$PSModuleAutoLoadingPreference = 'All'

$PowerShellModules = @(
  "Az"
  "ClassExplorer"
  "ImportExcel"
  "Pester"
  "posh-git"
  "powershell-yaml"
  "SqlServer"
)
function Install-PowerShellModules {
  Register-PSRepository -Default -ErrorAction SilentlyContinue
  Set-PSRepository -Name 'PSGallery' -Trusted -ErrorAction SilentlyContinue
  foreach ($module in $PowerShellModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
      Install-PSResource -Name $module -Repository PSGallery -Scope CurrentUser -TrustRepository -ErrorAction SilentlyContinue
    }
  }
}
# $PSModuleAutoLoadingPreferenceをAllにしているので、基本は使わなくていい
function Import-PowerShellModules {
  foreach ($module in $PowerShellModules) {
    if (Get-Module -ListAvailable -Name $module) {
      Import-Module -Name $module -Scope Global -ErrorAction SilentlyContinue
    }
  }
}

if ($IsWindows) {
  # Prompt Design
  if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
    $Env:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
    $Env:STARSHIP_CACHE = "$HOME\.starship\cache"
  }
  # Env
  $paths = @(
    "$($Env:LOCALAPPDATA)\DotNetVersions"
    "$($Env:LOCALAPPDATA)\ProcessExplorer"
    "$($Env:LOCALAPPDATA)\ULE4JIS"
  )
  foreach ($path in $paths) {
    if (-not ($Env:Path -split ';' | Where-Object { $_ -eq $path })) {
      $Env:Path = "$path;$Env:Path"
    }
  }
  # Alias
  Set-Alias -Name open -Value 'explorer.exe'
  Set-Alias -Name lg -Value 'lazygit.exe'
  Set-Alias -Name winmerge -Value "$HOME\AppData\Local\Programs\WinMerge\WinMergeU.exe"
  function Update-EnvironmentVariables {
    foreach ($scope in 'Machine', 'User') {
      [System.Environment]::GetEnvironmentVariables($scope).GetEnumerator() | ForEach-Object {
        [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value, 'Process')
      }
    }
  }
  function zsh { wsl /usr/bin/zsh }
  function ConvertTo-WslPath {
    param([Parameter(Mandatory, ValueFromPipeline)][string]$Path)
    return wsl --exec wslpath $Path
  }
  function nvim {
    param ([string]$Path)
    if ([string]::IsNullOrEmpty($Path)) {
      wsl nvim
    }
    else {
      wsl nvim $($Path | ConvertTo-WslPath)
    }
  }
}
elseif ($IsMacOS) {
  # Prompt Design
  Invoke-Expression (& '/usr/local/bin/starship' init powershell --print-full-init | Out-String)
  # Alias
  Set-Alias -Name lg -Value 'lazygit'
}

# プロンプト表示のため、posh-gitは明示的にインポートする
if (-not (Get-Module posh-git)) {
  Import-Module posh-git -ErrorAction SilentlyContinue
}
# Completion
$completionDir = Join-Path $HOME '.config/powershell/completions'
if (Test-Path $completionDir) {
  Get-ChildItem $completionDir -Filter '*.ps1' -File -ErrorAction SilentlyContinue |
  ForEach-Object { try { . $_.FullName } catch { } }
}
# PowerShell Options
Set-PSReadLineOption `
  -PredictionSource History `
  -PredictionViewStyle InlineView `
  -MaximumHistoryCount 200 `
  -HistorySearchCaseSensitive `
  -HistorySearchCursorMovesToEnd `
  -HistoryNoDuplicates `
  -BellStyle Visual
Set-PSReadLineKeyHandler `
  -Key Tab `
  -Function MenuComplete
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$PSStyle.FileInfo.Directory = $PSStyle.Foreground.Blue + $PSStyle.Bold
# Alias
Set-Alias -Name touch -Value New-Item
Set-Alias -Name ll -Value Get-ChildItem
function la { param($Path = ".") Get-ChildItem -Path $Path -Force }
function lla { param($Path = ".") Get-ChildItem -Path $Path -Force }
