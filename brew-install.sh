#!/bin/bash

type brew >/dev/null 2>&1 || {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >/dev/null
}

if [ "$(uname -s)" = "Linux" ]; then
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.bash_profile
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.profile
fi

echo "🍺 tap homebrew/bundle..."
brew tap homebrew/bundle >/dev/null

echo "🍺 doctor..."
brew doctor >/dev/null

echo "🍺 update..."
brew update >/dev/null

echo "🍺 upgrade..."
brew upgrade >/dev/null

echo "🍺 cleanup..."
brew cleanup >/dev/null

echo "🍺 bundle..."
brew bundle >/dev/null
