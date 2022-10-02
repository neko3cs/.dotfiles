#!/usr/bin/env pwsh

$PowerShellModules = @(
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
function Register-OhMyPoshSettings {
    oh-my-posh init pwsh `
        --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/stelbent.minimal.omp.json' | 
    Invoke-Expression
}

# Windows Only
if ($IsWindows) {
    Register-WingetCompletion

    ## Alias
    Set-Alias -Name winmerge -Value "$HOME\AppData\Local\Programs\WinMerge\WinMergeU.exe"
    Set-Alias -Name vim -Value 'C:\Program Files\Vim\vim82\vim.exe'
    Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
    function which {
        param(
            [parameter(Mandatory, ValueFromPipeline)][string]$command
        )
        return (Get-Command -Name $command -ShowCommandInfo).Definition
    }
}

# All Platform
Register-PowerShellModule
Register-OhMyPoshSettings
Register-DotNetCompletion

## Alias
Set-Alias -Name ll -Value Get-ChildItem
function lla {
    Get-ChildItem -Force
}
Set-Alias -Name touch -Value New-Item
