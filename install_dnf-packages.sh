#!/usr/bin/env bash

SCRIPT_ROOT="$(cd "$(dirname "$0")" && pwd)"
PACKAGES_FILE="$SCRIPT_ROOT/dnf-packages.txt"

# Microsoft Repository
curl -sSL -O https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
sudo rpm -i packages-microsoft-prod.rpm
rm packages-microsoft-prod.rpm
# zsh-completions Repository
sudo dnf copr enable -y clarlok/zsh-users
# lazygit Repository
sudo dnf copr enable -y dejan/lazygit

sudo dnf clean all
sudo dnf makecache -y
sudo dnf upgrade -y

PACKAGES=$(grep -vE '^#|^$' "$PACKAGES_FILE" | tr '\n' ' ')
sudo dnf install -y $PACKAGES --skip-unavailable
