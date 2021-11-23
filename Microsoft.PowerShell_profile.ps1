#!/usr/bin/env pwsh

function Install-PSModule {
    if (-not (Get-Module -ListAvailable -Name oh-my-posh)) {
        Install-Module -Name oh-my-posh -AllowPrerelease -Force
    }
    if (-not (Get-Module -ListAvailable -Name posh-git)) {
        Install-Module -Name posh-git
    }
    if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
        Install-Module -Name powershell-yaml
    }
    if (-not (Get-Module -ListAvailable -Name SqlServer)) {
        Install-Module -Name SqlServer
    }
    if (-not (Get-Module -ListAvailable -Name ClassExplorer)) {
        Install-Module -Name ClassExplorer
    }
    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        Install-Module -Name ImportExcel
    }
}

function Set-PSModule {
    if (-not (Get-Module -Name oh-my-posh)) {
        Import-Module oh-my-posh
        Set-PoshPrompt -Theme agnosterplus
    }
    if (-not (Get-Module -Name posh-git)) {
        Import-Module -Name posh-git
    }
    if (-not (Get-Module -Name powershell-yaml)) {
        Import-Module -Name powershell-yaml
    }
    if (-not (Get-Module -Name SqlServer)) {
        Import-Module SqlServer
    }
    if (-not (Get-Module -Name ClassExplorer)) {
        Import-Module ClassExplorer
    }
    if (-not (Get-Module -Name ImportExcel)) {
        Import-Module -Name ImportExcel
    }
}

if ($IsWindows) {
    # Alias
    Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
    Set-Alias -Name winmerge -Value "C:\Program Files\WinMerge\WinMergeU.exe"
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

    # PowerShell Module
    Install-PSModule
    Set-PSModule

    # winget completion
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
    # dotnet completion
    if (Get-Command dotnet -ea SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
            param($commandName, $wordToComplete, $cursorPosition)
            dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
}
