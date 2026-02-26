#!/usr/bin/env bash

set -e

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
install_aws_cli() {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
}
install_azure_cli() {
  curl -fsSL https://aka.ms/InstallAzureCLIDeb | sudo bash
}
install_docker() {
  sudo apt update && sudo apt upgrade -y
  sudo apt install curl apt-transport-https -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y
  sudo gpasswd -a $USER docker
  sudo service docker start
}
install_pwsh() {
  # Update the list of packages
  sudo apt-get update
  # Install pre-requisite packages.
  sudo apt-get install -y wget apt-transport-https software-properties-common
  # Get the version of Ubuntu
  source /etc/os-release
  # Download the Microsoft repository keys
  wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
  # Register the Microsoft repository keys
  sudo dpkg -i packages-microsoft-prod.deb
  # Delete the Microsoft repository keys file
  rm packages-microsoft-prod.deb
  # Update the list of packages after we added packages.microsoft.com
  sudo apt-get update
  # Install PowerShell
  sudo apt-get install -y powershell
}
install_pyenv() {
  curl https://pyenv.run | bash
}
install_starship() {
  curl -sS https://starship.rs/install.sh | sh
}
install_yq() {
  sudo curl -fsSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq
  sudo chmod +x /usr/bin/yq
}
install_zsh_completions() {
  git clone git@github.com:zsh-users/zsh-completions.git ~/.zsh/zsh-completions
  fpath=(~/.zsh/zsh-completions/src $fpath)
  rm -f ~/.zcompdump && compinit
}

cd $HOME
if  [ ! -d ./.dotfiles ]; then
  git clone https://github.com/neko3cs/.dotfiles.git
fi
cd .dotfiles

sudo apt update
sudo apt upgrade

activate_ubuntu

install_aws_cli
install_azure_cli
install_docker
install_starship
install_pwsh
install_pyenv
install_yq
install_zsh_completions
./install_apt-packages.sh
./install_pnpm-packages.sh
./install_vimplug.sh
./set_dotfiles.sh
./set_completions.sh
pwsh -File ./Set-Completions.ps1

sudo apt autoremove
sudo apt autoclean
