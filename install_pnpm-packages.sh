#!/bin/bash

set -e

PACKAGES_FILE="$(dirname "$0")/pnpm-global-packages.txt"

if ! command -v pnpm &> /dev/null; then
    echo "Error: pnpm is not installed. Please install pnpm first."
    exit 1
fi

if [ -f "$PACKAGES_FILE" ]; then
    echo "Installing global pnpm packages..."
    while IFS= read -r package || [ -n "$package" ]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" =~ ^# ]] && continue
        
        echo "Installing $package..."
        pnpm add -g "$package"
    done < "$PACKAGES_FILE"
    echo "All pnpm packages installed successfully."
else
    echo "Error: $PACKAGES_FILE not found."
    exit 1
fi
