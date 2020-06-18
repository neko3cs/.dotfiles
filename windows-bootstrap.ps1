#!/usr/local/bin/pwsh

$title = "clone .dotfiles repo and run bootstrap scripts."
$message = "ok?: "
$options = [System.Management.Automation.Host.ChoiceDescription[]](
    (New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "実行する"),
    (New-Object System.Management.Automation.Host.ChoiceDescription "&No", "実行しない")
)
$result = $Host.UI.PromptForChoice($title, $message, $options, 1)
if ($result -ne 0) { exit } 

# FIXME: windows is not installed default git
git clone https://github.com/neko3cs/.dotfiles.git
Set-Location .dotfiles

pwsh -File .\pwsh-profile-link.ps1
pwsh -File .\chocolatey-install.ps1
pwsh -File .\vscode-extensions-install.ps1
