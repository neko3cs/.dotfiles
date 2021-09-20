#!/bin/bash

activate_ubuntu() {
  # change dash->bash by selecting <No>
  sudo dpkg-reconfigure dash
  # japanese lang pack
  sudo apt install -y language-pack-ja
  # locale japanese
  sudo update-locale LANG=ja_JP.UTF-8
  # timezone azia/tokyo
  sudo dpkg-reconfigure tzdata
  # japanese man
  sudo apt install -y manpages-ja manpages-ja-dev
}

install_zsh_completions() {
  git clone git://github.com/zsh-users/zsh-completions.git ~/zsh-completions
  fpath=(~/zsh-completions/src $fpath)
  rm -f ~/.zcompdump; compinit
}

echo "clone .dotfiles repo and run bootstrap scripts."
read -p "ok?(y/N): " yn; case "$yn" in [yY]*) ;; *) exit;; esac

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

sudo apt update
sudo apt upgrade

activate_ubuntu

# for install homebrew
sudo apt-get install build-essential procps curl file git

./brew-install.sh
./vim-install.sh
./dotfiles-link.sh

install_zsh_completions

sudo apt autoremove
sudo apt autoclean
