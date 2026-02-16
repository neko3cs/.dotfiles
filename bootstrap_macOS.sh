#!/bin/zsh

setup_java() {
  sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
}
setup_completions() {
  if [ ! -d ~/.zsh/completion ]; then
    mkdir -p ~/.zsh/completion
  fi
  if [ ! -e ~/.zsh/completion/_docker-compose ]; then
    mkdir -p ~/.zsh/completion
    curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose >~/.zsh/completion/_docker-compose
  fi
  deno completions zsh > ~/.zsh/completion/_deno
  deno run -A npm:@angular/cli completion script > ~/.zsh/completion/_ng
  minikube completion zsh > ~/.zsh/completion/_minikube
  sqlcmd completion zsh > ~/.zsh/completion/_sqlcmd
}

cd $HOME
if  [ ! -d ./.dotfiles ]; then
  git clone https://github.com/neko3cs/.dotfiles.git
fi
cd .dotfiles

softwareupdate --install

./brew-install.sh
./install_pnpm-packages.sh
setup_java
setup_completions
./vimplug-install.sh
./dotfiles-link.sh
./set_macOS_defaults.sh

