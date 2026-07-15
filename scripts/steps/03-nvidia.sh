#!/usr/bin/env bash
set -euo pipefail
if ! command -v nvidia-smi >/dev/null 2>&1; then
  sudo apt install -y ubuntu-drivers-common
  sudo ubuntu-drivers install
  echo "Pilote installé. Redémarre puis relance ./install.sh"
  exit 1
fi
count="$(nvidia-smi --query-gpu=index --format=csv,noheader | wc -l)"
[[ "$count" -eq 3 ]] || { echo "$count GPU détectés, 3 attendus"; exit 1; }
