#!/bin/zsh

dotfiles=(
  .vimrc
  .tmux.conf
  .zshrc
  .zlogin
)

for dotfile in "${dotfiles[@]}"; do
  ln -sf $(pwd)/$dotfile ~/$dotfile
done

source ~/.zshrc
source ~/.zlogin
