#!/usr/bin/env bash

set -euo pipefail

echo "Updating package repositories..."

sudo apt-get update

echo "Installing Nginx..."

sudo apt-get install -y nginx

echo "Enabling Nginx service..."

sudo systemctl enable nginx

echo "Starting Nginx service..."

sudo systemctl start nginx

echo "Validating installation..."

nginx -v

sudo systemctl status nginx --no-pager

echo "Nginx installation completed successfully."