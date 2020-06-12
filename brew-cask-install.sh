#!/bin/sh

type brew >/dev/null 2>&1 || {
  echo "  command 'brew' not found!"
  echo "  please run 'brew-install.sh' before this."
  exit;
}

brew doctor
brew update
brew upgrade

taps=(
  caskroom/cask
)

casks=(
  appcleaner
  docker
  google-chrome
  google-japanese-ime
  github
  hub
  java
  microsoft-edge
  powershell
  springboot
  unity-hub
  visual-studio-code
  visual-studio
  xmind
)

for tap in "${taps[@]}"; do
  brew tap $tap
done

for cask in "${casks[@]}"; do
  brew cask install $cask || brew cask upgrade $cask
done

brew cleanup
