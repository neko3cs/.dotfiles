#!pwsh

$extensions = @(
    "ms-vscode.azure-account"
    "ms-vscode.azurecli"
    "ms-dotnettools.csharp"
    "ms-vscode.cmake-tools"
    "ms-ceintl.vscode-language-pack-ja"
    "ms-vsliveshare.vsliveshare"
    "ms-vscode.powershell"
    "ms-mssql.mssql"
    "jtlowe.vscode-icon-theme"
    "gruntfuggly.todo-tree"
    "visualstudioexptteam.vscodeintellicode"
)

foreach ($extension in $extensions) {
    code --install-extension $extension
}
