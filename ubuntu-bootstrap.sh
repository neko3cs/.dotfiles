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

install_pwsh() {
  # Update the list of packages
  sudo apt-get update
  # Install pre-requisite packages.
  sudo apt-get install -y wget apt-transport-https software-properties-common
  # Download the Microsoft repository GPG keys
  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
  # Register the Microsoft repository GPG keys
  sudo dpkg -i packages-microsoft-prod.deb
  # Update the list of packages after we added packages.microsoft.com
  sudo apt-get update
  # Install PowerShell
  sudo apt-get install -y powershell
  # Delete deb file
  rm ./packages-microsoft-prod.deb
}

echo "clone .dotfiles repo and run bootstrap scripts."
read -p "ok? (y/N): " yn; case "$yn" in [yY]*) echo "continue..." *) exit 0;; esac

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

sudo apt update
sudo apt upgrade

activate_ubuntu

./vimplug-install.sh
install_apt_package_for_linuxbrew
./brew-install.sh
install_zsh_completions
install_pwsh
./dotfiles-link.sh

sudo apt autoremove
sudo apt autoclean
