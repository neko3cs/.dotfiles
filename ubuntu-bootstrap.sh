#!/bin/sh

sudo apt update
sudo apt upgrade

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

# install homebrew
sudo apt install build-essential curl file git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
