#!/usr/bin/env zsh

set -e

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
./set_completions.sh
pwsh -File ./Set-Completions.ps1
