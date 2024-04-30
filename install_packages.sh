#!/bin/sh

PKGMNG=$1

if [ -z "$PKGMNG" ]; then
  echo 'usage: install_packages.sh <package_manager>'
  echo 'package_manager: ex; apt, yum, pacman...'
  exit
fi

packages=$(cat $HOME/.dotfiles/config/packages.csv)

if [ "$PKGMNG" = "apt" ]; then
  echo "$packages" | \
  awk -F ',' '$1=="all" {print $2}' | \
  xargs -P1 sudo apt install > /dev/null

  echo "$packages" | \
  awk -F ',' '$1=="apt" {print $2}' | \
  xargs -P1 sudo apt install > /dev/null
elif [ "$PKGMNG" = "pacman" ]; then
  echo "$packages" | \
  awk -F ',' '$1=="all" {print $2}' | \
  xargs -P1 sudo pacman -S > /dev/null

  echo "$packages" | \
  awk -F ',' '$1=="pacman" {print $2}' | \
  xargs -P1 sudo pacman -S > /dev/null
fi
