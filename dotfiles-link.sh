#!/usr/bin/env zsh

dotfiles=(
  .vimrc
  Brewfile
)
dotfiles_need_source=(
  .zprofile
  .zshrc
)

for dotfile in "${dotfiles[@]}"; do
  ln -sf $(pwd)/$dotfile ~/$dotfile
done
for dotfile in "${dotfiles_need_source[@]}"; do
  ln -sf $(pwd)/$dotfile ~/$dotfile
  source $(pwd)/$dotfile
done
