#!/bin/sh

xcode-select --install

sh ./dotfiles-link.sh
sh ./vim-install.sh
sh ./brew-install.sh
sh ./brew-cask-install.sh
# 以下2つはいずれ docker に開発環境を作るのでそのうち消える
sh ./npm-install.sh
sh ./gem-install.sh

