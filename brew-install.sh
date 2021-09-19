#!/bin/bash

type brew >/dev/null 2>&1 || {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
  cmake
  ghc
  git
  github/gh/gh
  go
  jq
  mas
  mysql
  nkf
  node
  open-cobol
  tmux
  reattach-to-user-namespace # for tmux
  rbenv
  redis
  rust
  sqlite
  watchman
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
  github
  java
  notion
  powershell
  unity-hub
  visual-studio-code
  visual-studio
  vlc
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
