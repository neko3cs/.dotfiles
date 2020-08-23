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
