#!pwsh

if ($IsWindows) {
    Set-Alias -Name acrobat -Value 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'
    Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
    
    switch ($env:COMPUTERNAME) {
        "NEKO3CS-PARALLE" { 
            Set-Alias -Name visualstudio -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"
        }
        Default { 
            Set-Alias -Name visualstudio -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"
            Set-Alias -Name winmerge -Value "C:\Program Files\WinMerge\WinMergeU.exe"
        }
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
    Get-Command -Name $command -ShowCommandInfo | Select-Object Definition
}
