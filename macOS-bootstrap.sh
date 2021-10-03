#!/bin/zsh

install_docker_completion() {
  if [ ! -e ~/.zsh/completion/_docker-compose ]; then
    mkdir -p ~/.zsh/completion
    curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose >~/.zsh/completion/_docker-compose
  fi
}

echo "clone .dotfiles repo and run bootstrap scripts."
echo -n "ok?(y/N): "
read -q && echo "continue..." || exit 0

git clone https://github.com/neko3cs/.dotfiles.git
cd .dotfiles

softwareupdate --install

./vimplug-install.sh
./brew-install.sh
install_docker_completion
pwsh ./vscode-extensions-install.ps1
./dotfiles-link.sh
