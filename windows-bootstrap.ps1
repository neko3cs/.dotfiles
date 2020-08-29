#!pwsh

$title = "clone .dotfiles repo and run bootstrap scripts."
$message = "ok?: "
$options = [System.Management.Automation.Host.ChoiceDescription[]](
    (New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "実行する"),
    (New-Object System.Management.Automation.Host.ChoiceDescription "&No", "実行しない")
)
$result = $Host.UI.PromptForChoice($title, $message, $options, 1)
if ($result -ne 0) { exit } 

# windows is not default installed git.
if (!(Get-Command choco -ea SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
choco install git.install --yes --params="'/NoShellIntegration /NoAutoCrlf'"

git clone https://github.com/neko3cs/.dotfiles.git
Set-Location .dotfiles

pwsh -File .\Set-PwshProfile.ps1
pwsh -File .\Install-ChocolateyApps.ps1
pwsh -File .\Install-VisualStudioCodeExtensions.ps1
pwsh -File .\Install-VisualStudio.ps1
pwsh -File .\Install-SQLServerManagementStudio.ps1
pwsh -File .\Install-DockerDesktopForWindows.ps1
