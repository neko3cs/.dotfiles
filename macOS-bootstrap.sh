#!/bin/zsh

install_vim_plug() {
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

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

xcode-select --install

install_vim_plug
./brew-install.sh
install_docker_completion
pwsh ./vscode-extensions-install.ps1
./dotfiles-link.sh
