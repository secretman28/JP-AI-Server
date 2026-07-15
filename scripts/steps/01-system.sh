#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt install -y build-essential git cmake ninja-build curl wget jq unzip rsync python3 python3-pip python3-venv ca-certificates gnupg htop btop tmux pciutils nfs-common ccache libssl-dev pkg-config
