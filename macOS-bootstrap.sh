#!/bin/bash

echo "clone .dotfiles repo and run bootstrap scripts."
read -p "ok?(y/N): " yn; case "$yn" in [yY]*) ;; *) exit;; esac

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

xcode-select --install

./dotfiles-link.sh
./brew-install.sh
./brew-cask-install.sh
./vim-install.sh
pwsh ./vscode-extensions-install.ps1
