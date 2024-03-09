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
  git clone git@github.com:zsh-users/zsh-completions.git ~/zsh-completions
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
install_yq() {
  sudo curl -fsSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq
  sudo chmod +x /usr/bin/yq
}
install_rustup() {
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh
}
install_pyenv() {
  curl https://pyenv.run | bash
}
install_azure_cli() {
  curl -fsSL https://aka.ms/InstallAzureCLIDeb | sudo bash
}
install_aws_sam_cli() {
  curl -fsSL https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip -o ~/aws-sam-cli-linux-x86_64.zip
  unzip ~/aws-sam-cli-linux-x86_64.zip -d ~/sam-installer
  sudo ~/sam-installer/install && rm -rf ~/sam-installer/
}

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

sudo apt update
sudo apt upgrade

activate_ubuntu

sudo apt install $(cat ./config/packages.txt)
install_zsh_completions
install_pwsh
install_yq
install_rustup
install_azure_cli
install_aws_sam_cli
./vimplug-install.sh
./dotfiles-link.sh

sudo apt autoremove
sudo apt autoclean
