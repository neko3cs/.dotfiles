#!/bin/zsh

setup_completions() {
  if [ ! -d ~/.zsh/completion ]; then
    mkdir -p ~/.zsh/completion
  fi
  curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose
  deno completions zsh > ~/.zsh/completion/_deno
  minikube completion zsh > ~/.zsh/completion/_minikube
  pnpx @angular/cli completion script > ~/.zsh/completion/_ng
  starship completion zsh > ~/.zsh/completion/_starship
  sqlcmd completion zsh > ~/.zsh/completion/_sqlcmd
}

cd $HOME
if  [ ! -d ./.dotfiles ]; then
  git clone https://github.com/neko3cs/.dotfiles.git
fi
cd .dotfiles

softwareupdate --install

./install_brewformulas.sh
./install_pnpm-packages.sh
./install_vimplug.sh
./set_dotfiles.sh
./set_macOS_defaults.sh
setup_completions
