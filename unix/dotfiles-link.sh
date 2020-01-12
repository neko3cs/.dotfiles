#!/bin/sh

dotfiles=(
  .vimrc
  .tmux.conf
  .zprofile
  .zshrc
)

for dotfile in "${dotfiles[@]}"; do
  ln -sf $(pwd)/$dotfile ~/$dotfile
done

