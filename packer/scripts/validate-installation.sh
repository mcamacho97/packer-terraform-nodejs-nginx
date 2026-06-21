#!/usr/bin/env bash

set -euo pipefail

node -v

npm -v

nginx -v

sudo systemctl is-active nginx

sudo systemctl is-active nodeapp

curl http://localhost