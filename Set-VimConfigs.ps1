#!/usr/bin/env pwsh

[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $ReplaceVimRc,
  [Parameter()]
  [switch]
  $Force
)

if ($Force) {
  if (Test-Path -Path $HOME/.vim/bundle/) {
    Remove-Item `
      -Path $HOME/.vim/bundle/ `
      -Recurse `
      -Force
  }
  if (Test-Path -Path $HOME/.vimrc) {
    Remove-Item `
      -Path $HOME/.vimrc `
      -Force
  }
}

if (-not (Test-Path -Path $HOME/.vim/bundle/)) {
  mkdir $HOME/.vim/bundle/
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
}
if ((-not (Test-Path -Path $HOME/.vimrc)) -or $ReplaceVimRc) {
  Copy-Item `
    -Path $HOME\.dotfiles\.vimrc `
    -Destination $HOME\.vimrc
}
