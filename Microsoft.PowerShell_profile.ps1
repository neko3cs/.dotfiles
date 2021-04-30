#!pwsh

function Set-PSModule {
    if (Get-Command Get-PoshThemes -ea SilentlyContinue) {
        Import-Module oh-my-posh
        Set-PoshPrompt -Theme agnosterplus
    }
    if (!(Get-Command Get-GitStatus -ea SilentlyContinue)) {
        Import-Module -Name posh-git
    }
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if (Test-Path($ChocolateyProfile)) {
        Import-Module "$ChocolateyProfile"
    }
    if (Get-Command Get-SqlCmd -ea SilentlyContinue) {
        Import-Module sqlserver
    }
    if (!(Get-Command Import-Excel -ea SilentlyContinue)) {
        Import-Module -Name ImportExcel
    }
}

if ($IsWindows) {
    Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
    Set-Alias -Name winmerge -Value "C:\Program Files\WinMerge\WinMergeU.exe"
    
    Set-PSModule
    
    if ((vswhere -utf8 -format json | ConvertFrom-Json).Length -ne 0) {
        $visualstudioPath = (vswhere -utf8 -format json) |
        ConvertFrom-Json |
        Select-Object -ExpandProperty productPath
        Set-Alias -Name visualstudio -Value $visualstudioPath
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
    ubuntu zsh
}
