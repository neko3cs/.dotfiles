#!/usr/bin/env pwsh

param(
  [switch]$Force
)

if ($Force) {
  if (Test-Path $HOME/.vim/bundle/) {
    Remove-Item `
      -Path $HOME/.vim/bundle/ `
      -Force
  }
  if (Test-Path $HOME/.vim/colors/) {
    Remove-Item `
      -Path $HOME/.vim/colors/ `
      -Force
  }
}

# vim-plug
if (-not (Test-Path $HOME/.vim/bundle/)) {
  New-Item `
    -Path $HOME/.vim/bundle/ `
    -ItemType Directory `
    -Force
}
Invoke-WebRequest `
  -UseBasicParsing `
  -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |
New-Item `
  -Path $HOME/vimfiles/autoload/plug.vim `
  -Force
# codedark.vim
if (-not (Test-Path $HOME/.vim/colors/)) {
  New-Item `
    -Path $HOME/.vim/colors/ `
    -ItemType Directory `
    -Force
}
git clone https://github.com/tomasiser/vim-code-dark.git $HOME/.vim/bundle/vim-code-dark.git
Copy-Item `
  -Path $HOME/.vim/bundle/vim-code-dark.git/colors/codedark.vim `
  -Destination $HOME/.vim/colors/codedark.vim
