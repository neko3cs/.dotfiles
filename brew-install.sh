#!/bin/bash

type brew >/dev/null 2>&1 || {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

brew doctor
brew update
brew upgrade

taps=(
  azure/functions
  pivotal/tap
)

formulas=(
  azure-cli
  azure-functions-core-tools
  automake
  boost
  ghc
  git
  github/gh/gh
  go
  jq
  mas
  mysql
  node
  open-cobol
  tmux
  reattach-to-user-namespace # for tmux
  rbenv
  redis
  rust
  sqlite
  wget
  yarn
  zsh
  zsh-completions
)

casks=(
  appcleaner
  discord
  docker
  dropbox
  google-chrome
  google-japanese-ime
  github
  java
  mysqlworkbench
  notion
  powershell
  unity-hub
  visual-studio-code
  visual-studio
  zoom
)

for tap in "${taps[@]}"; do
  brew tap $tap
done

for formula in "${formulas[@]}"; do
  brew install $formula || brew upgrade $formula
done

for cask in "${casks[@]}"; do
  brew install --cask $cask || brew upgrade --cask $cask
done

brew cleanup
