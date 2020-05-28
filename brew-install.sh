#!/bin/sh

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
  node
  open-cobol
  tmux
  reattach-to-user-namespace # for tmux
  rbenv
  redis
  sqlite
  wget
  yarn
  zsh
  zsh-completions
)

for tap in "${taps[@]}"; do
  brew tap $tap
done

for formula in "${formulas[@]}"; do
  brew install $formula || brew upgrade $formula
done

brew cleanup
