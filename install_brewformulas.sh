#!/usr/bin/env zsh

SCRIPT_ROOT="$(dirname "$0")"

type brew >/dev/null 2>&1 || {
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh >/dev/null
}

echo "🍺 update..."
brew update >/dev/null

echo "🍺 upgrade..."
brew upgrade >/dev/null

echo "🍺 bundle..."
brew bundle --file=$SCRIPT_ROOT/Brewfile

echo "🍺 autoremove..."
brew autoremove >/dev/null

echo "🍺 cleanup..."
brew cleanup >/dev/null

echo "🍺 doctor..."
brew doctor >/dev/null
