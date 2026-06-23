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

if (Get-Command -Name aws -ErrorAction SilentlyContinue) {
  @'
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
'@ | Out-File -FilePath (Join-Path $completionDir "_aws.ps1") -Encoding UTF8
}
if (Get-Command -Name az -ErrorAction SilentlyContinue) {
  @'
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
'@ | Out-File -FilePath (Join-Path $completionDir "_az.ps1") -Encoding UTF8
}
if ($IsWindows -and (Get-Command -Name winget -ErrorAction SilentlyContinue)) {
  @'
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}
'@ | Out-File -FilePath (Join-Path $completionDir "_winget.ps1") -Encoding UTF8
}
