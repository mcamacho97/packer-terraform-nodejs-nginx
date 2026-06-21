#!/usr/bin/env bash

set -euo pipefail

echo "Updating packages..."

sudo apt-get update

echo "Installing dependencies..."

sudo apt-get install -y \
    curl \
    ca-certificates \
    gnupg

echo "Installing NodeJS..."

curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -

sudo apt-get install -y nodejs

echo "Node version:"
node -v

echo "NPM version:"
npm -v