#!pwsh

# Execute this command and copy & paste to array initialization.
# PS> code --list-extensions | select { "`"$_`"" }
$extensions = @(
    "Angular.ng-template"
    "chrmarti.regex"
    "eamodio.gitlens"
    "eightHundreds.vscode-drawio"
    "esbenp.prettier-vscode"
    "Gruntfuggly.todo-tree"
    "humao.rest-client"
    "jebbs.plantuml"
    "jtlowe.vscode-icon-theme"
    "ms-azuretools.vscode-docker"
    "MS-CEINTL.vscode-language-pack-ja"
    "ms-dotnettools.csharp"
    "ms-mssql.mssql"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "ms-vscode-remote.remote-containers"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode.azure-account"
    "ms-vscode.azurecli"
    "ms-vscode.cmake-tools"
    "ms-vscode.cpptools"
    "ms-vscode.powershell"
    "ms-vsliveshare.vsliveshare"
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
