#!/bin/bash

set -e

PACKAGES_FILE="$(dirname "$0")/pnpm-global-packages.txt"

# Ensure corepack is installed
if ! command -v corepack &> /dev/null; then
    echo "corepack not found. Installing corepack via npm..."
    npm install -g corepack
fi

# Ensure pnpm is enabled
if ! command -v pnpm &> /dev/null; then
    echo "pnpm not found or not enabled. Enabling pnpm via corepack..."
    corepack use pnpm@latest
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
