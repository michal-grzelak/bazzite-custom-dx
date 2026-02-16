#!/usr/bin/env bash
# Install @devcontainers/cli globally via npm
# Requires npm to be available (via brew)

set -e

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "npm not found - skipping devcontainer CLI installation"
    echo "Make sure brew is installed and PATH includes ~/.linuxbrew/bin"
    exit 0
fi

echo "Installing @devcontainers/cli..."

# Install globally with sudo if needed (for system-wide availability)
if [ -w "$(npm root -g)" ]; then
    npm install -g @devcontainers/cli
else
    sudo npm install -g @devcontainers/cli
fi

echo "@devcontainers/cli installed successfully"
