#Requires -Version 7.0
Set-StrictMode -Version Latest

if ($IsWindows)
{
    New-Item -ItemType File -Force -Path $PROFILE | Out-Null
    Copy-Item -Force -Path $PSScriptRoot\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.gitconfig -Value $PSScriptRoot\.gitconfig | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.claude/settings.json -Value $PSScriptRoot\claude-settings.json | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.claude/CLAUDE.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType Directory -Force -Path $HOME/.codex | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.codex/AGENTS.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.copilot/settings.json -Value $PSScriptRoot\copilot-settings.json | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.copilot/copilot-instructions.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType Directory -Force -Path $HOME/.gemini | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.gemini/GEMINI.md -Value $PSScriptRoot\AGENTS.global.md | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.starship/starship.toml -Value $PSScriptRoot\starship.toml | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.config/bat/config -Value $PSScriptRoot\bat_config | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $HOME/.textlintrc.json -Value $PSScriptRoot\.textlintrc.json | Out-Null
    New-Item -ItemType SymbolicLink -Force -Path $env:APPDATA\Zed\settings.json -Value $PSScriptRoot\zed-settings.json | Out-Null
} elseif ($IsMacOS)
{
    Copy-Item -Force -Path $PSScriptRoot\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE | Out-Null
}
