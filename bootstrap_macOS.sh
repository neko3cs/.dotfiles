#!/bin/zsh

install_docker_completion() {
  if [ ! -e ~/.zsh/completion/_docker-compose ]; then
    mkdir -p ~/.zsh/completion
    curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose >~/.zsh/completion/_docker-compose
  fi
}
setup_java() {
  sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
}

cd $HOME
if  [ ! -d ./.dotfiles ]; then
  git clone https://github.com/neko3cs/.dotfiles.git
fi
cd .dotfiles

softwareupdate --install

./brew-install.sh
setup_java
install_docker_completion
./vimplug-install.sh
./dotfiles-link.sh
