#!/bin/zsh

install_docker_completion() {
  if [ ! -e ~/.zsh/completion/_docker-compose ]; then
    mkdir -p ~/.zsh/completion
    curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose >~/.zsh/completion/_docker-compose
  fi
}
install_rust() {
  rustup-init --quiet -y
  rustup component add rustfmt rust-analyzer
}

cd $HOME
if  [ ! -d ./.dotfiles ]; then
  git clone https://github.com/neko3cs/.dotfiles.git
fi
cd .dotfiles

softwareupdate --install

./brew-install.sh
install_docker_completion
install_rust
./vimplug-install.sh
./dotfiles-link.sh
