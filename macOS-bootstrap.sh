#!/bin/sh

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

xcode-select --install

sh ./dotfiles-link.sh
sh ./vim-install.sh
sh ./brew-install.sh
sh ./brew-cask-install.sh
