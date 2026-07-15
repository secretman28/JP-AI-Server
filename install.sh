#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "Erreur ligne $LINENO" >&2' ERR
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT/config/jp-ai.env"
[[ $EUID -ne 0 ]] || { echo "Lance avec ton utilisateur normal."; exit 1; }
mountpoint -q "$AI_ROOT" || { echo "$AI_ROOT non monté"; exit 1; }
touch "$AI_ROOT/.write-test" && rm -f "$AI_ROOT/.write-test" || { echo "$AI_ROOT non écrivable"; exit 1; }

echo '[1/8] Structure NFS'
mkdir -p "$AI_ROOT"/{models/llama-cache,cache/huggingface,projects,docker/open-webui,docker/searxng/config,docker/searxng/valkey,codebase-memory,backups,logs,scripts,temp}

echo '[2/8] Paquets'
sudo apt update
sudo apt install -y build-essential git cmake ninja-build curl wget jq unzip rsync python3 python3-pip python3-venv ca-certificates gnupg htop btop tmux pciutils nfs-common

echo '[3/8] llama.cpp CUDA'
if [[ ! -d "$HOME/llama.cpp/.git" ]]; then git clone https://github.com/ggml-org/llama.cpp "$HOME/llama.cpp"; else git -C "$HOME/llama.cpp" pull; fi
cmake -S "$HOME/llama.cpp" -B "$HOME/llama.cpp/build" -G Ninja -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release
cmake --build "$HOME/llama.cpp/build" -j"$(nproc)" --target llama-server llama-cli llama-bench

echo '[4/8] Docker'
if ! command -v docker >/dev/null; then curl -fsSL https://get.docker.com | sh; fi
sudo usermod -aG docker "$USER"
sudo systemctl enable --now docker

echo '[5/8] Configuration'
sudo mkdir -p /etc/jp-ai
sudo cp "$ROOT/config/jp-ai.env" /etc/jp-ai/jp-ai.env
sudo cp "$ROOT/config/models.json" /etc/jp-ai/models.json
sudo cp "$ROOT/config/models.ini" /etc/jp-ai/models.ini
sudo install -m 0755 "$ROOT/bin/jp" /usr/local/bin/jp
sudo install -m 0755 "$ROOT/bin/jp-doctor" /usr/local/bin/jp-doctor
sudo install -m 0755 "$ROOT/bin/jp-benchmark" /usr/local/bin/jp-benchmark
sudo install -m 0755 "$ROOT/bin/jp-codebase-memory-install" /usr/local/bin/jp-codebase-memory-install

echo '[6/8] Docker stack'
mkdir -p "$HOME/jp-ai-stack"
cp "$ROOT/docker/docker-compose.yml" "$HOME/jp-ai-stack/docker-compose.yml"
cp "$ROOT/docker/searxng-settings.yml" "$AI_ROOT/docker/searxng/config/settings.yml"
SECRET=$(openssl rand -hex 32)
sed -i "s/CHANGE_ME_SECRET/$SECRET/" "$AI_ROOT/docker/searxng/config/settings.yml"

echo '[7/8] systemd'
sudo cp "$ROOT/systemd/jp-llama-router.service" /etc/systemd/system/
sudo cp "$ROOT/systemd/jp-stack.service" /etc/systemd/system/
sudo sed -i "s|__USER__|$USER|g; s|__HOME__|$HOME|g" /etc/systemd/system/jp-llama-router.service /etc/systemd/system/jp-stack.service
sudo systemctl daemon-reload
sudo systemctl enable jp-llama-router.service jp-stack.service
sudo systemctl start jp-llama-router.service
sudo systemctl start jp-stack.service || true

echo '[8/8] Terminé'
echo 'Reboot recommandé: sudo reboot'
