# PowerShell Profile

Set-Alias -Name acrobat -Value 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'
Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
Set-Alias -Name ll -Value Get-ChildItem
function Get-ChildItem-All {
    Get-ChildItem -Force
}
Set-Alias -Name la -Value Get-ChildItem-All
Set-Alias -Name touch -Value New-Item

switch ($env:COMPUTERNAME) {
    "NEKO3CS-PARALLE" { 
        Set-Alias -Name visualstudio -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"
    }
    Default { 
        Set-Alias -Name visualstudio -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"
        Set-Alias -Name winmerge -Value "C:\Program Files\WinMerge\WinMergeU.exe"
    }
}

$MyPSModules = (
    'C:\Repos\pwsh-tools\modules\PwshTools.CryptSecretString\'
)
foreach ($module in $MyPSModules) {
    if (Test-Path $module) {
        Import-Module $module
    }
}
