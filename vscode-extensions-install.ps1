#!pwsh

$extensions = @(
    "angular.ng-template"
    "ms-vscode.azure-account"
    "ms-vscode.azurecli"
    "ms-vscode.cpptools"
    "ms-dotnettools.csharp"
    "ms-vscode.cmake-tools"
    "ms-azuretools.vscode-docker"
    "golang.go"
    "ms-ceintl.vscode-language-pack-ja"
    "ms-vsliveshare.vsliveshare"
    "yzane.markdown-pdf"
    "jebbs.plantuml"
    "ms-vscode.powershell"
    "humao.rest-client"
    "ms-mssql.mssql"
    "jtlowe.vscode-icon-theme"
    "gruntfuggly.todo-tree"
    "visualstudioexptteam.vscodeintellicode"
    "tomoki1207.pdf"
)

foreach ($extension in $extensions) {
    code --install-extension $extension
}
