#!/usr/bin/env pwsh

Invoke-WebRequest `
  -UseBasicParsing `
  -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |
New-Item `
  -Path $HOME/vimfiles/autoload/plug.vim `
  -Force

if (-not (Test-Path $HOME/.vim/bundle/)) {
  mkdir -Path $HOME/.vim/bundle/
}
git clone https://github.com/tomasiser/vim-code-dark.git $HOME/.vim/bundle/vim-code-dark.git
if (-not (Test-Path $HOME/.vim/colors/codedark.vim)) {
  mkdir -Path $HOME/.vim/colors/
}
Copy-Item `
  -Path $HOME/.vim/bundle/vim-code-dark.git/colors/codedark.vim `
  -Destination $HOME/.vim/colors/codedark.vim
