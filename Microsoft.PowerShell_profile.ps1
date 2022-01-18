#!/usr/bin/env pwsh

$PowerShellModules = @(
    "oh-my-posh"
    "posh-git"
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
    Set-PoshPrompt -Theme stelbent.minimal # oh-my-posh settings
}
function Register-WingetCompletion {
    if (Get-Command winget -ea SilentlyContinue) {
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
function Register-DotNetCompletion {
    if (Get-Command dotnet -ea SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
            param($commandName, $wordToComplete, $cursorPosition)
            dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
}

if ($IsWindows) {
    Register-PowerShellModule
    Register-WingetCompletion
    Register-DotNetCompletion

    # Alias
    Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
    Set-Alias -Name winmerge -Value "C:\Program Files (x86)\WinMerge\WinMergeU.exe"
    Set-Alias -Name ll -Value Get-ChildItem
    function lla {
        Get-ChildItem -Force
    }
    Set-Alias -Name touch -Value New-Item
    function which {
        param(
            [parameter(Mandatory, ValueFromPipeline)][string]$command
        )
        return (Get-Command -Name $command -ShowCommandInfo).Definition
    }
}
