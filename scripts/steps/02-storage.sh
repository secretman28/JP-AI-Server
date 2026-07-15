#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../config/server.env"
mountpoint -q "$AI_MOUNT" || { echo "$AI_MOUNT non monté"; exit 1; }
touch "$AI_MOUNT/.jp-ai-test" && rm -f "$AI_MOUNT/.jp-ai-test"
mkdir -p "$AI_MOUNT"/{projects,backups,logs,scripts,temp,codebase-memory} "$AI_MOUNT/models/llama-cache" "$AI_MOUNT/cache/huggingface" "$AI_MOUNT/docker/open-webui" "$AI_MOUNT/docker/searxng/config" "$AI_MOUNT/docker/searxng/valkey"
