# Windows Powershell

# TODO: 連想配列で管理
# TODO: 実態があるとResourceExistsエラーするので事前に削除する　->　本当に消してよいか確認
New-Item -Value .\Microsoft.PowerShell_profile.ps1 -Path $env:USERPROFILE\Documents\PowerShell\ -Name 'Microsoft.PowerShell_profile.ps1' -ItemType SymbolicLink
