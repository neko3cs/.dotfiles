#!/bin/bash

brew update

outdated=$(brew outdated)

if [ -n "$outdated" ]; then
    cat << EOF

The following package(s) will upgrade.
$outdated

Are you sure?
If you don't want to upgrade, please type Ctrl-c now.
EOF

  read dummy

  brew cleanup
  brew upgrade

fi

brew install automake
brew install azure-cli
brew tap azure/functions; brew install azure-functions-core-tools
brew install boost
brew install node
brew install oauth-toolkit
brew install open-cobol
brew cask install powershell
brew install rbenv
brew install redis
brew install sqlite
brew install wget

