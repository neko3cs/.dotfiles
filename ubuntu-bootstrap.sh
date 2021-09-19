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

add_homebrew_path() {
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.bash_profile
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.profile
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

add_homebrew_path

./vim-install.sh
./dotfiles-link.sh

install_zsh_completions

chsh -s $(which zsh)

sudo apt autoremove
sudo apt autoclean
