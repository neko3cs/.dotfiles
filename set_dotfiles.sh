#!/usr/bin/env zsh

SCRIPT_ROOT="$(dirname "$0")"

# .zshrc
ln -sf $SCRIPT_ROOT/.zshrc $HOME/.zshrc
source ~/.zshrc
# pwsh
mkdir -p $HOME/.config/powershell
cp -f $SCRIPT_ROOT/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
# starship
mkdir -p $HOME/.starship
ln -sf $SCRIPT_ROOT/starship.toml $HOME/.starship/starship.toml
# ghostty
mkdir -p $HOME/.config/ghostty
ln -sf $SCRIPT_ROOT/ghostty_config $HOME/.config/ghostty/config
# bat
mkdir -p $HOME/.config/bat
ln -sf $SCRIPT_ROOT/bat_config $HOME/.config/bat/config
# neovim init.lua
mkdir -p $HOME/.config/nvim
ln -sf $SCRIPT_ROOT/init.lua $HOME/.config/nvim/init.lua
# .gitconfig
ln -sf $SCRIPT_ROOT/.gitconfig $HOME/.gitconfig
# Homebrew
ln -sf $SCRIPT_ROOT/Brewfile $HOME/Brewfile
# .textlintrc.json
ln -sf $SCRIPT_ROOT/.textlintrc.json $HOME/.textlintrc.json
