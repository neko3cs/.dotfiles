# PowerShell Core

$extentions = @(
    ms-ceintl.vscode-language-pack-ja
    ms-vscode.csharp
    visualstudioexptteam.vscodeintellicode
    ms-vsliveshare.vsliveshare
    ms-vscode.powershell
    ms-vscode.azure-account
    ms-mssql.mssql
    gruntfuggly.todo-tree
)

foreach ($extention in $extentions) {    
    code --install-extension $extention
}
