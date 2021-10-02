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

install_vim_plug() {
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_apt_package_for_linuxbrew() {
  sudo apt-get install \
    build-essential \
    procps \
    curl \
    file \
    git
}

install_zsh_completions() {
  # TODO: homebrewから入れてるからいらないのでは？->確認して消す
  git clone git://github.com/zsh-users/zsh-completions.git ~/zsh-completions
  fpath=(~/zsh-completions/src $fpath)
  rm -f ~/.zcompdump
  compinit
}

echo "clone .dotfiles repo and run bootstrap scripts."
read -n1 -p "ok? (y/N): " yn
[[ $yn = [yY] ]] && echo "continue..." || exit 0

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

sudo apt update
sudo apt upgrade

activate_ubuntu

install_vim_plug
install_apt_package_for_linuxbrew
./brew-install.sh
install_zsh_completions
./dotfiles-link.sh

sudo apt autoremove
sudo apt autoclean
