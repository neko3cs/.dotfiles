#!/bin/bash

set -e

PACKAGES_FILE="$(dirname "$0")/npm-global-packages.txt"

if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install Node.js first."
    exit 1
fi

if [ -f "$PACKAGES_FILE" ]; then
    echo "Installing global npm packages..."
    while IFS= read -r package || [ -n "$package" ]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" =~ ^# ]] && continue
        
        echo "Installing $package..."
        npm install -g "$package"
    done < "$PACKAGES_FILE"
    echo "All npm packages installed successfully."
else
    echo "Error: $PACKAGES_FILE not found."
    exit 1
fi
