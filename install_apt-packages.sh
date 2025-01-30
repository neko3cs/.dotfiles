#!/bin/sh

while IFS= read -r package; do
  if [ -n "$package" ]; then
    sudo apt install -y "$package" > /dev/null
  fi
done < "$HOME/.dotfiles/config/apt-packages.txt"
