#!/usr/bin/env bash

PACKAGES_FILE="$(dirname "$0")/dnf-packages.txt"

# Microsoft Repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft-2025.asc
sudo dnf install -y https://packages.microsoft.com/config/rhel/10/packages-microsoft-prod.rpm
# zsh-completions Repository
sudo dnf copr enable clarlok/zsh-users -y

PACKAGES=$(grep -vE '^#|^$' "$PACKAGES_FILE" | tr '\n' ' ')
sudo dnf install -y $PACKAGES
