# PowerShell Profile

Set-Alias -Name acrobat -Value 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'
Set-Alias -Name open -Value 'C:\Windows\explorer.exe'
# Set-Alias -Name visualstudio -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"
Set-Alias -Name visualstudio -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"
Set-Alias -Name ll -Value Get-ChildItem
function Get-ChildItem-All {
    Get-ChildItem -Force
}
Set-Alias -Name la -Value Get-ChildItem-All
Set-Alias -Name grep -Value Select-String
function Find-ChildItem {
    # TODO: linuxのfindコマンドと同じようになるように修正する
    param (
        [string]$name
    )
    Get-ChildItem -Recurse -Include $name
}
Set-Alias -Name find -Value Find-ChildItem
