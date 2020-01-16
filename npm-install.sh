#!/bin/sh

type brew >/dev/null 2>&1 || {
  echo "please install homebrew before run this script."
  exit
}

type npm >/dev/null 2>&1 || {
  brew install node
}

packages=(
  npm
  @angular/cli
  @vue/cli
  react
  react-dom
  react-native-cli
  create-react-app
  bower
  typescript
  webpack
  webpack-cli
)

for package in "${packages[@]}"; do
  npm install -g $package
done
