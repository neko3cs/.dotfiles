#!/usr/bin/env zsh

SCRIPT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$SCRIPT_ROOT/Brewfile"

type brew >/dev/null 2>&1 || {
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh >/dev/null
}

echo "🍺 update..."
brew update >/dev/null

echo "🍺 upgrade..."
brew upgrade >/dev/null

echo "🍺 bundle..."
brew bundle --file=$BREWFILE

echo "🍺 autoremove..."
brew autoremove >/dev/null

echo "🍺 cleanup..."
brew cleanup >/dev/null

echo "🍺 doctor..."
brew doctor >/dev/null
