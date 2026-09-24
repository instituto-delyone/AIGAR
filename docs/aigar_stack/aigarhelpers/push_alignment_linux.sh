#!/usr/bin/env bash
# ==== Copia o arquivo de alinhamento para a inbox (Linux/macOS) ====
set -euo pipefail
cd "$(dirname "$0")"

STACK="AIGAR_STACK"
SRC="./AIGAR_alignment_boot.jsonl"
DEST="$STACK/io/inbox/AIGAR_alignment_boot.jsonl"

if [[ ! -d "$STACK/io/inbox" ]]; then
  echo "[ERRO] Nao encontrei a pasta '$STACK/io/inbox'" >&2
  exit 1
fi

if [[ ! -f "$SRC" ]]; then
  echo "[ERRO] Nao encontrei '$SRC'" >&2
  exit 1
fi

cp -f "$SRC" "$DEST"
echo "[OK] Arquivo copiado para a inbox."
