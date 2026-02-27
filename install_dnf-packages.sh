#!/usr/bin/env bash

PACKAGES_FILE="$(dirname "$0")/dnf-packages.txt"

# Microsoft Repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
# zsh-completions Repository
sudo dnf copr enable -y clarlok/zsh-users
# lazygit Repository
sudo dnf copr enable -y dejan/lazygit

sudo dnf clean all
sudo dnf makecache -y

PACKAGES=$(grep -vE '^#|^$' "$PACKAGES_FILE" | tr '\n' ' ')
sudo dnf install -y $PACKAGES --skip-unavailable
