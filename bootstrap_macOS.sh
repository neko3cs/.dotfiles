#!/usr/bin/env zsh
set -e

cd $HOME
if  [ ! -d $HOME/.dotfiles ]; then
  git clone https://github.com/neko3cs/.dotfiles.git
fi
cd .dotfiles

SCRIPT_ROOT="$(dirname "$0")"

softwareupdate --install

. $SCRIPT_ROOT/install_brewformulas.sh
. $SCRIPT_ROOT/install_pnpm-packages.sh
. $SCRIPT_ROOT/set_dotfiles.sh
. $SCRIPT_ROOT/set_macOS_defaults.sh
. $SCRIPT_ROOT/set_completions.sh
pwsh -File $SCRIPT_ROOT/Set-Completions.ps1
