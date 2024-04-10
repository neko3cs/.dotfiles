#!/bin/sh

PKGMNG=$1

if [ -z "$PKGMNG" ]; then
  echo 'usage: install-package.sh <package_manager>'
  echo 'package_manager: ex; apt, yum, pacman...'
  exit
fi

packages=$(cat $HOME/.dotfiles/config/packages.txt)

if [ "$PKGMNG" = "apt" ]; then
  echo "$packages" | \
  awk -F ',' '$1=="all" {print $2}' | \
  xargs -I {} sudo apt install {} > /dev/null

  echo "$packages" | \
  awk -F ',' '$1=="apt" {print $2}' | \
  xargs -I {} sudo apt install {} > /dev/null
elif [ "$PKGMNG" = "pacman" ]; then
  echo "$packages" | \
  awk -F ',' '$1=="all" {print $2}' | \
  xargs -I {} sudo pacman -S {} > /dev/null

  echo "$packages" | \
  awk -F ',' '$1=="pacman" {print $2}' | \
  xargs -I {} sudo pacman -S {} > /dev/null
fi
