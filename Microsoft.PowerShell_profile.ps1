#!/usr/bin/env pwsh

function Install-PSModule {
    if (-not (Get-Module -ListAvailable -Name oh-my-posh)) {
        Install-Module -Name oh-my-posh -AllowPrerelease -Force
    }
    if (-not (Get-Module -ListAvailable -Name posh-git)) {
        Install-Module -Name posh-git
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
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if ((Test-Path($ChocolateyProfile)) -and (-not (Get-Module -Name chocolateyProfile))) {
        Import-Module "$ChocolateyProfile"
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
    function zsh {
        wsl zsh
    }

    # PowerShell Module
    Install-PSModule
    Set-PSModule

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
