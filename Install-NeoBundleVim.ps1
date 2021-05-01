#!pwsh
#
# NeoBundle Vim Install Script
# Source: https://github.com/Shougo/neobundle.vim
#

if (Test-Path -Path "$HOME/.vim/bundle/") {
  Remove-Item -Recurse -Path "$HOME/.vim/bundle/"
}

mkdir $HOME/.vim/bundle/
git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
