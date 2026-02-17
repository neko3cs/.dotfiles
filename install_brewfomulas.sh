#!/bin/bash

type brew >/dev/null 2>&1 || {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >/dev/null
}

echo "🍺 update..."
brew update >/dev/null

echo "🍺 upgrade..."
brew upgrade >/dev/null

echo "🍺 bundle..."
brew bundle --file=$(pwd)/Brewfile

echo "🍺 cleanup..."
brew cleanup >/dev/null

echo "🍺 doctor..."
brew doctor >/dev/null
