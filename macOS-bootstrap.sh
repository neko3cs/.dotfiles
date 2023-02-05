#!/bin/zsh

install_docker_completion() {
  if [ ! -e ~/.zsh/completion/_docker-compose ]; then
    mkdir -p ~/.zsh/completion
    curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose >~/.zsh/completion/_docker-compose
  fi
}

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

softwareupdate --install

./dotfiles-link.sh
./vimplug-install.sh
./brew-install.sh
install_docker_completion
pwsh ./vscode-extensions-install.ps1

rustup component add rustfmt-preview --toolchain stable-x86_64-apple-darwin

