#Requires -PSEdition Core

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
function Register-AwsCliCompletion {
  if (Get-Command -Name aws -ea SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName aws -ScriptBlock {
      param($commandName, $wordToComplete, $cursorPosition)
      $env:COMP_LINE = $wordToComplete
      if ($env:COMP_LINE.Length -lt $cursorPosition) {
        $env:COMP_LINE = $env:COMP_LINE + " "
      }
      $env:COMP_POINT = $cursorPosition
      aws_completer.exe | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
      }
      Remove-Item Env:\COMP_LINE
      Remove-Item Env:\COMP_POINT
    }
  }
}
function Register-AzureCliCompletion {
  if (Get-Command -Name az -ea SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
      param($commandName, $wordToComplete, $cursorPosition)
      $completion_file = New-TemporaryFile
      $env:ARGCOMPLETE_USE_TEMPFILES = 1
      $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
      $env:COMP_LINE = $wordToComplete
      $env:COMP_POINT = $cursorPosition
      $env:_ARGCOMPLETE = 1
      $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
      $env:_ARGCOMPLETE_IFS = "`n"
      $env:_ARGCOMPLETE_SHELL = 'powershell'
      az 2>&1 | Out-Null
      Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
      }
      Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
    }  
  }
}
function Register-DotNetCompletion {
  if (Get-Command -Name dotnet -ea SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
      param($commandName, $wordToComplete, $cursorPosition)
      dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
      }
    }
  }
}
function Register-WingetCompletion {
  if (Get-Command -Name winget -ea SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
      param($wordToComplete, $commandAst, $cursorPosition)
      [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
      $Local:word = $wordToComplete.Replace('"', '""')
      $Local:ast = $commandAst.ToString().Replace('"', '""')
      winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
      }
    }
  }
}


if ($IsWindows) {
  # Prompt Design
  Invoke-Expression (&starship init powershell)
  # Completion
  Register-WingetCompletion
  # Env
  $Env:JAVA_HOME = "$HOME\AppData\Local\Programs\Microsoft\jdk-17.0.10.7-hotspot"
  $Env:ANDROID_HOME = "$HOME\AppData\Local\Android\Sdk"
  $Env:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
  $Env:STARSHIP_CACHE = "$HOME\.starship\cache"
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
deno completions powershell | Out-String | Invoke-Expression
starship completions power-shell | Out-String | Invoke-Expression
pip completion --powershell | Out-String | Invoke-Expression
Register-AwsCliCompletion
Register-AzureCliCompletion
Register-DotNetCompletion
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
