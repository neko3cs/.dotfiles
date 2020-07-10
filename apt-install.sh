#!/bin/bash

sudo apt update 
sudo apt upgrade

pkgs=(
  git
  tmux
  reattach-to-user-namespace # for tmux
  zsh
  zsh-completions
)

for pkg in "${pkgs[@]}"; do
  sudo apt install $pkg || sudo apt upgrade $pkgs
done

sudo apt autoremove
sudo apt autoclean
