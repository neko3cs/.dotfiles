#!/usr/bin/env zsh

SCRIPT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# 設定ファイルは配置先と同じフォルダ構成でリポジトリに置いてある。
# 例外は AGENTS.global.md (配置先が4箇所あるため単一のミラーパスに置けない)。

# .zshrc
ln -sf $SCRIPT_ROOT/.zshrc $HOME/.zshrc
source $HOME/.zshrc
# pwsh
mkdir -p $HOME/.config/powershell
cp -f $SCRIPT_ROOT/.config/powershell/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
# starship
mkdir -p $HOME/.starship
ln -sf $SCRIPT_ROOT/.starship/starship.toml $HOME/.starship/starship.toml
# ghostty
mkdir -p $HOME/.config/ghostty
ln -sf $SCRIPT_ROOT/.config/ghostty/config $HOME/.config/ghostty/config
# bat
mkdir -p $HOME/.config/bat
ln -sf $SCRIPT_ROOT/.config/bat/config $HOME/.config/bat/config
# neovim init.lua
mkdir -p $HOME/.config/nvim
ln -sf $SCRIPT_ROOT/.config/nvim/init.lua $HOME/.config/nvim/init.lua
# claude code
mkdir -p $HOME/.claude
ln -sf $SCRIPT_ROOT/.claude/settings.json $HOME/.claude/settings.json
ln -sf $SCRIPT_ROOT/AGENTS.global.md $HOME/.claude/CLAUDE.md
# codex
mkdir -p $HOME/.codex
ln -sf $SCRIPT_ROOT/AGENTS.global.md $HOME/.codex/AGENTS.md
ln -sf $SCRIPT_ROOT/.codex/hooks.json $HOME/.codex/hooks.json
cp -f $SCRIPT_ROOT/.codex/config.toml $HOME/.codex/config.toml
# GitHub Copilot
mkdir -p $HOME/.copilot
ln -sf $SCRIPT_ROOT/.copilot/settings.json $HOME/.copilot/settings.json
ln -sf $SCRIPT_ROOT/AGENTS.global.md $HOME/.copilot/copilot-instructions.md
# gemini (antigravity-cli)
mkdir -p $HOME/.gemini
ln -sf $SCRIPT_ROOT/AGENTS.global.md $HOME/.gemini/GEMINI.md
# .gitconfig
ln -sf $SCRIPT_ROOT/.gitconfig $HOME/.gitconfig
# Homebrew
ln -sf $SCRIPT_ROOT/Brewfile $HOME/Brewfile
# .textlintrc.json
ln -sf $SCRIPT_ROOT/.textlintrc.json $HOME/.textlintrc.json
# Zed
mkdir -p $HOME/.config/zed
ln -sf $SCRIPT_ROOT/.config/zed/settings.json $HOME/.config/zed/settings.json
