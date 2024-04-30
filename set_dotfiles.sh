#!/usr/bin/env zsh

ln -sf $(pwd)/config/.zshrc $HOME/.zshrc
source ~/.zshrc
ln -sf $(pwd)/config/starship.toml $HOME/.starship/starship.toml
ln -sf $(pwd)/config/.vimrc $HOME/.vimrc
ln -sf $(pwd)/config/.gitconfig $HOME/.gitconfig
ln -sf $(pwd)/config/Brewfile $HOME/Brewfile
