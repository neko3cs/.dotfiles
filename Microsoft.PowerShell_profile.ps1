#!pwsh

if ($IsWindows) {
    Set-Alias -Name acrobat -Value 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'
    Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
    Set-Alias -Name winmerge -Value "C:\Program Files\WinMerge\WinMergeU.exe"
    if ((vswhere -utf8 -format json | ConvertFrom-Json).Length -ne 0) {
        $visualstudioPath = (vswhere -utf8 -format json) |
        ConvertFrom-Json |
        Select-Object -ExpandProperty productPath
        Set-Alias -Name visualstudio -Value $visualstudioPath
    }
    if (Get-Command dotnet -ea SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
            param($commandName, $wordToComplete, $cursorPosition)
            dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
    if (Get-Command Get-PoshThemes -ea SilentlyContinue) {
        Import-Module oh-my-posh
        Set-PoshPrompt -Theme agnosterplus
    }
}

Set-Alias -Name ll -Value Get-ChildItem
function la {
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
