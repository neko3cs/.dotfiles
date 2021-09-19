#!/usr/bin/env zsh

dotfiles=(
  .vimrc
  .zprofile
  .zshrc
)

for dotfile in "${dotfiles[@]}"; do
  ln -sf $(pwd)/$dotfile ~/$dotfile
done

source ~/.zprofile
source ~/.zshrc
