#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$ROOT/config/server.env"
STATE_DIR="/var/lib/jp-ai/state"
LOG_DIR="/var/log/jp-ai"
LOG_FILE="$LOG_DIR/install.log"

if [[ ! -f "$ENV_FILE" ]]; then
  cp "$ROOT/config/server.env.example" "$ENV_FILE"
  sed -i "s|/home/CHANGE_ME|$HOME|g" "$ENV_FILE"
fi
source "$ENV_FILE"
sudo mkdir -p "$STATE_DIR" "$LOG_DIR"
sudo touch "$LOG_FILE"
sudo chown "$USER:$USER" "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
trap 'echo "ERREUR ligne $LINENO. Consulte $LOG_FILE"' ERR

run_step(){
  local id="$1"; shift
  local marker="$STATE_DIR/$id.done"
  if sudo test -f "$marker"; then echo "[SKIP] $id"; return; fi
  echo; echo "========== $id =========="
  "$@"
  sudo touch "$marker"
}
run_step 01-system "$ROOT/scripts/steps/01-system.sh"
run_step 02-storage "$ROOT/scripts/steps/02-storage.sh"
run_step 03-nvidia "$ROOT/scripts/steps/03-nvidia.sh"
run_step 04-cuda "$ROOT/scripts/steps/04-cuda.sh"
run_step 05-llama "$ROOT/scripts/steps/05-llama.sh"
run_step 06-docker "$ROOT/scripts/steps/06-docker.sh"
run_step 07-services "$ROOT/scripts/steps/07-services.sh"
run_step 08-final "$ROOT/scripts/steps/08-final.sh"
echo; echo "Installation terminée. Lance: jp doctor"
