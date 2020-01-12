#!/bin/sh

type brew >/dev/null 2>&1 || {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

brew doctor
brew update
brew upgrade

taps=(
  azure/functions
)

formulas=(
  azure-cli
  azure-functions-core-tools
  automake
  boost
  ghc
  git
  go
  node
  open-cobol
  tmux
  rbenv
  redis
  sqlite
  wget
  yarn
)

casks=(
  amethyst
  appcleaner
  docker
  google-chrome
  github
  hub
  kindle
  powershell
  visual-studio-code
  visual-studio
)

for tap in "${taps[@]}"; do
  brew tap $tap
done

for formula in "${formulas[@]}"; do
  brew install $formula || brew upgrade $formula
done

for cask in "${casks[@]}"; do
  brew cask install $cask || brew cask upgrade $cask
done

brew cleanup
