#Requires -Version 7.0
Set-StrictMode -Version Latest

if ($IsWindows)
{
    # symlink の親ディレクトリが無いと New-Item が失敗するため先に作る
    foreach ($Dir in @("$HOME/.claude", "$HOME/.codex", "$HOME/.copilot", "$HOME/.gemini", "$HOME/.starship", "$HOME/.config/bat", "$env:APPDATA\Zed"))
    {
        New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    }

    New-Item -ItemType File -Force -Path $PROFILE | Out-Null
    Copy-Item -Force -Path $PSScriptRoot\.config\powershell\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Value $PSScriptRoot\.gitconfig | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.claude/settings.json -Value $PSScriptRoot\.claude\settings.json | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.claude/CLAUDE.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.codex/AGENTS.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.codex/hooks.json -Value $PSScriptRoot\.codex\hooks.json | Out-Null
    Copy-Item -Force -Path $PSScriptRoot\.codex\config.toml -Destination $HOME/.codex/config.toml | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.copilot/settings.json -Value $PSScriptRoot\.copilot\settings.json | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.copilot/copilot-instructions.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.gemini/GEMINI.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.starship/starship.toml -Value $PSScriptRoot\.starship\starship.toml | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.config/bat/config -Value $PSScriptRoot\.config\bat\config | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.textlintrc.json -Value $PSScriptRoot\.textlintrc.json | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $env:APPDATA\Zed\settings.json -Value $PSScriptRoot\.config\zed\settings.json | Out-Null
} elseif ($IsMacOS)
{
    # macOS のメインシェルは zsh。pwsh は補助用途なのでプロファイルのみ配置する
    Copy-Item -Force -Path $PSScriptRoot\.config\powershell\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
}
