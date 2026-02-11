#!/usr/bin/env zsh

# .zshrc
ln -sf $(pwd)/.zshrc $HOME/.zshrc
source ~/.zshrc
# pwsh
mkdir -p $HOME/.config/powershell
cp -f $(pwd)/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
# starship
mkdir -p $HOME/.starship
ln -sf $(pwd)/starship.toml $HOME/.starship/starship.toml
# ghostty
mkdir -p $HOME/.config/ghostty
ln -sf $(pwd)/ghostty_config $HOME/.config/ghostty/config
# bat
mkdir -p $HOME/.config/bat
ln -sf $(pwd)/bat_config $HOME/.config/bat/config
# .vimrc
ln -sf $(pwd)/.vimrc $HOME/.vimrc
# .gitconfig
ln -sf $(pwd)/.gitconfig $HOME/.gitconfig
# Homebrew
ln -sf $(pwd)/Brewfile $HOME/Brewfile

