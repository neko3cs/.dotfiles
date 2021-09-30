#!/usr/bin/env pwsh

param (
  [switch]$Force
)

if ($Force) {
  if (Test-Path -Path $HOME/.vim/bundle/) {
    Remove-Item `
      -Path $HOME/.vim/bundle/ `
      -Recurse `
      -Force
  }
}

if (-not (Test-Path -Path $HOME/.vim/bundle/)) {
  mkdir $HOME/.vim/bundle/
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
}
