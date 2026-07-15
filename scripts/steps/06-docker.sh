#!/usr/bin/env bash
set -euo pipefail
if ! command -v docker >/dev/null 2>&1; then curl -fsSL https://get.docker.com | sh; fi
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
