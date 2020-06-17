#!/bin/sh

xcode-select --install

sh ./dotfiles-link.sh
sh ./vim-install.sh
sh ./brew-install.sh
sh ./brew-cask-install.sh
