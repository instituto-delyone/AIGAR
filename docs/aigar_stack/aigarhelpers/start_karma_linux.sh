#!/usr/bin/env bash
# ==== Start Karma (Linux/macOS) ====
set -euo pipefail
cd "$(dirname "$0")"
STACK="AIGAR_STACK/karma"

if [[ ! -f "$STACK/karma_core.py" ]]; then
  echo "[ERRO] Nao encontrei $STACK/karma_core.py" >&2
  exit 1
fi

echo "Iniciando Karma..."
cd "$STACK"
python3 karma_core.py
