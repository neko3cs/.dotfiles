#!/bin/bash

set -e

PACKAGES_FILE="$(dirname "$0")/npm-packages.txt"

if ! command -v corepack &> /dev/null; then
    echo "corepack not found. Installing corepack via npm..."
    npm install -g corepack
fi
if ! command -v pnpm &> /dev/null; then
    echo "pnpm not found or not enabled. Enabling pnpm via corepack..."
    corepack use pnpm@latest
fi

if [ -f "$PACKAGES_FILE" ]; then
    while IFS= read -r package || [ -n "$package" ]; do
        [[ -z "$package" || "$package" =~ ^# ]] && continue
        pnpm add -g "$package"
    done < "$PACKAGES_FILE"
else
    echo "Error: $PACKAGES_FILE not found."
    exit 1
fi
