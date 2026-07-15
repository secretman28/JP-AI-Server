#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../config/server.env"
LLAMA_DIR="${LLAMA_DIR/CHANGE_ME/$USER}"
if [[ ! -d "$LLAMA_DIR/.git" ]]; then git clone https://github.com/ggml-org/llama.cpp "$LLAMA_DIR"; else git -C "$LLAMA_DIR" pull --ff-only; fi
cmake -S "$LLAMA_DIR" -B "$LLAMA_DIR/build" -G Ninja -DGGML_CUDA=ON -DGGML_CCACHE=ON -DCMAKE_BUILD_TYPE=Release
cmake --build "$LLAMA_DIR/build" -j"$(nproc)" --target llama-server llama-cli
test -x "$LLAMA_DIR/build/bin/llama-server"
