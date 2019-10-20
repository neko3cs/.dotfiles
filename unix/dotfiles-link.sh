#!/bin/sh

dotfiles=(
  .vimrc
  .zprofile
  .zshrc
)

for dotfile in "${dotfiles[@]}"; do
  ln -sf ~/dotfiles/unix/$dotfile ~/$dotfile
done

source ~/.zprofile
source ~/.zshrc # TODO: maybe, is it unnecessary?
