# PowerShell Core

$extentions = @(
    ms-vscode.azure-account
    ms-vscode.csharp
    ms-vscode.cmake-tools
    ms-ceintl.vscode-language-pack-ja
    ms-vsliveshare.vsliveshare
    ms-vscode.powershell
    ms-mssql.mssql
    jtlowe.vscode-icon-theme
    gruntfuggly.todo-tree
    visualstudioexptteam.vscodeintellicode
)

foreach ($extention in $extentions) {    
    code --install-extension $extention
}
