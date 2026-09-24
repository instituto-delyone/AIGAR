#!/usr/bin/env bash
# ==== Criptografar/descriptografar arquivo (Linux/macOS) ====
# Preferencia: OpenSSL AES-256-CBC com PBKDF2.
# Uso:
#   ./encrypt_alignment_linux.sh encrypt AIGAR_alignment_boot.jsonl
#   ./encrypt_alignment_linux.sh decrypt AIGAR_alignment_boot.jsonl.enc

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Uso: $0 <encrypt|decrypt> <arquivo>" >&2
  exit 1
fi

OP="$1"
FILE="$2"

if ! command -v openssl >/dev/null 2>&1; then
  echo "[ERRO] 'openssl' nao encontrado. Instale o OpenSSL." >&2
  exit 1
fi

read -rsp "Digite a SENHA (seu CPF, somente numeros): " CPF
echo

if [[ "$OP" == "encrypt" ]]; then
  openssl enc -aes-256-cbc -pbkdf2 -salt -in "$FILE" -out "$FILE.enc" -pass pass:"$CPF"
  echo "[OK] Criado: $FILE.enc (AES-256-CBC + PBKDF2)"
  exit 0
fi

if [[ "$OP" == "decrypt" ]]; then
  OUT="${FILE%.enc}"
  openssl enc -d -aes-256-cbc -pbkdf2 -in "$FILE" -out "$OUT" -pass pass:"$CPF"
  echo "[OK] Restaurado: $OUT"
  exit 0
fi

echo "[ERRO] Operacao invalida. Use encrypt ou decrypt." >&2
exit 1
