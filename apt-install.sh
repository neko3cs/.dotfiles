#!/bin/bash

sudo apt update
sudo apt upgrade

pkgs=(
  cmake
  git
  nkf
  tmux
  reattach-to-user-namespace # for tmux
  zsh
  zsh-completions
)

for pkg in "${pkgs[@]}"; do
  sudo apt install $pkg || sudo apt upgrade $pkgs
done

git clone git://github.com/zsh-users/zsh-completions.git ~/zsh-completions
fpath=(~/zsh-completions/src $fpath)
rm -f ~/.zcompdump; compinit

sudo apt autoremove
sudo apt autoclean
