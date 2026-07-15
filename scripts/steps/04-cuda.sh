#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../config/server.env"
if ! command -v nvcc >/dev/null 2>&1; then sudo apt install -y "$CUDA_PACKAGE"; fi
if ! command -v nvcc >/dev/null 2>&1 && [[ -x /usr/local/cuda/bin/nvcc ]]; then sudo ln -sf /usr/local/cuda/bin/nvcc /usr/local/bin/nvcc; fi
nvcc --version
