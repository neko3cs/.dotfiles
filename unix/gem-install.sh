#!/bin/sh

# gem is built in macOS

gems=(
  rails
  bundler
  iStats
)

gem update

for gem in "${gems[@]}"; do
  gem install rails
done
