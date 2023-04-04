#!/usr/bin/env zsh

dotfiles=(
  .vimrc
  .gitconfig
  Brewfile
)
dotfiles_need_source=(
  .zprofile
  .zshrc
)

for dotfile in "${dotfiles[@]}"; do
  ln -sf $(pwd)/config/$dotfile ~/$dotfile
done
for dotfile in "${dotfiles_need_source[@]}"; do
  ln -sf $(pwd)/config/$dotfile ~/$dotfile
  source ~/$dotfile
done
