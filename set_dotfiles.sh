#!/usr/bin/env zsh

ln -sf $(pwd)/.zshrc $HOME/.zshrc
source ~/.zshrc
mkdir -p $HOME/.config/powershell
cp -f $(pwd)/Microsoft.PowerShell_profile.ps1 $HOME/.config/powershell/Microsoft.PowerShell_profile.ps1
ln -sf $(pwd)/starship.toml $HOME/.starship/starship.toml
mkdir -p $HOME/.config/ghostty
ln -sf $(pwd)/ghostty_config $HOME/.config/ghostty/config
ln -sf $(pwd)/.vimrc $HOME/.vimrc
ln -sf $(pwd)/.gitconfig $HOME/.gitconfig
ln -sf $(pwd)/Brewfile $HOME/Brewfile
