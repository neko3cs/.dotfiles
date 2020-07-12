#!/bin/zsh

dotfiles=(
  .vimrc
  .tmux.conf
  .zprofile
  .zshrc
  .zlogin
)

for dotfile in "${dotfiles[@]}"; do
  ln -sf $(pwd)/$dotfile ~/$dotfile
done

source ~/.zprofile
source ~/.zshrc
source ~/.zlogin

# wsl2 ubuntu settings
os_name=`awk -F= '$1=="NAME" { print $2 ;}' /etc/os-release | sed 's/"//g'`
if [ $os_name = "Ubuntu" ]; then
  ln -sf $(pwd)/.bash_login ~/.bash_login
  source ~/.bash_login
fi
