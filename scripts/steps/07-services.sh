#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT/config/server.env"
LLAMA_DIR="${LLAMA_DIR/CHANGE_ME/$USER}"
sudo mkdir -p /etc/jp-ai /opt/jp-ai
sudo cp "$ROOT/config/models.json" /etc/jp-ai/
sudo cp "$ROOT/config/models.ini" /etc/jp-ai/
sudo cp "$ROOT/config/server.env" /etc/jp-ai/
sudo install -m 0755 "$ROOT/bin/jp" /usr/local/bin/jp
sudo install -m 0755 "$ROOT/bin/jp-doctor" /usr/local/bin/jp-doctor
sudo install -m 0755 "$ROOT/bin/jp-model-pull" /usr/local/bin/jp-model-pull
sudo install -m 0755 "$ROOT/bin/jp-benchmark" /usr/local/bin/jp-benchmark
sudo cp "$ROOT/systemd/jp-llama-router.service" /etc/systemd/system/
sudo sed -i "s|__USER__|$USER|g; s|__LLAMA_DIR__|$LLAMA_DIR|g" /etc/systemd/system/jp-llama-router.service
sudo cp "$ROOT/docker/docker-compose.yml" /opt/jp-ai/
sudo cp "$ROOT/docker/searxng-settings.yml" /mnt/AI/docker/searxng/config/settings.yml
sudo systemctl daemon-reload
sudo systemctl enable --now jp-llama-router.service
sudo docker compose -f /opt/jp-ai/docker-compose.yml up -d
