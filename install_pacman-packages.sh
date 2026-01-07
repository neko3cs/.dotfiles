#!/bin/sh

while IFS= read -r package; do
  if [ -n "$package" ]; then
    sudo pacman -S --noconfirm "$package" > /dev/null
  fi
done < "$HOME/.dotfiles/pacman-packages.txt"
