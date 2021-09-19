#!/usr/bin/env pwsh

# Execute this command and copy & paste to array initialization.
# PS> code --list-extensions | Select-Object @{Name="Extensions";Expression={ "`"$_`"" }}
$extensions = @(
    "ajhyndman.jslint"
    "Angular.ng-template"
    "chrmarti.regex"
    "DavidAnson.vscode-markdownlint"
    "eamodio.gitlens"
    "eightHundreds.vscode-drawio"
    "Gruntfuggly.todo-tree"
    "humao.rest-client"
    "ICS.japanese-proofreading"
    "jebbs.plantuml"
    "jtlowe.vscode-icon-theme"
    "ms-azuretools.vscode-docker"
    "MS-CEINTL.vscode-language-pack-ja"
    "ms-dotnettools.csharp"
    "ms-mssql.mssql"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-vscode-remote.remote-containers"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode.azure-account"
    "ms-vscode.azurecli"
    "ms-vscode.cmake-tools"
    "ms-vscode.cpptools"
    "ms-vscode.powershell"
    "ms-vsliveshare.vsliveshare"
    "msjsdiag.vscode-react-native"
    "oderwat.indent-rainbow"
    "ritwickdey.LiveServer"
    "techer.open-in-browser"
    "tomoki1207.pdf"
    "twxs.cmake"
    "VisualStudioExptTeam.vscodeintellicode"
    "yzane.markdown-pdf"
)

foreach ($extension in $extensions) {
    code --install-extension $extension
}
