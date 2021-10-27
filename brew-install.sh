#!/bin/bash

type brew >/dev/null 2>&1 || {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

if [ "$(uname -s)" = "Linux" ]; then
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.bash_profile
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.profile
fi

brew doctor
brew update
brew upgrade

taps=(
  azure/functions
  pivotal/tap
)

formulas=(
  awscli
  azure-cli
  azure-functions-core-tools
  automake
  boost
  cmake
  ghc
  git
  gh
  go
  jq
  mysql
  nkf
  node
  open-cobol
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

if [ "$(uname -s)" = "Darwin" ]; then
  for cask in "${casks[@]}"; do
    brew install --cask $cask || brew upgrade --cask $cask
  done
fi

brew cleanup
