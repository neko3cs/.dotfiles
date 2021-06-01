# Windows PowerShell

# Confirmation to run
# $title = "clone .dotfiles repo and run bootstrap scripts."
# $message = "ok?: "
# $options = [System.Management.Automation.Host.ChoiceDescription[]](
#     (New-Object System.Management.Automation.Host.ChoiceDescription#  "&Yes", "実行する"),
#     (New-Object System.Management.Automation.Host.ChoiceDescription "# &No", "実行しない")
# )
# $result = $Host.UI.PromptForChoice($title, $message, $options, 1)
# if ($result -ne 0) { exit } 

# Set Execution Polycy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Install Chocolatey
if (-not (Get-Command choco -ea SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
# Windows is not default installed git
if (-not (Get-Command git -ea SilentlyContinue)) {
    choco install git.install --yes --params="'/NoShellIntegration /NoAutoCrlf'"
}

# Clone .dotfiles
if (!(Test-Path $HOME\.dotfiles)) {
    git clone https://github.com/neko3cs/.dotfiles.git
    Set-Location .dotfiles
}

# Run PSScripts
powershell -File .\Set-PwshProfile.ps1
powershell -File .\Install-ChocolateyApps.ps1
powershell -File .\Install-VisualStudioCodeExtensions.ps1
powershell -File .\Install-VisualStudio.ps1
powershell -File .\Install-SQLServerManagementStudio.ps1
