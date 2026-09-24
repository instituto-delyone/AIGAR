
SEGURANCA & SENHA (CPF)
-----------------------
- A pedido seu, a SENHA sera o seu CPF (somente numeros).
- IMPORTANTE: usar CPF como senha e fraco contra ataques direcionados.
  Recomendado: futuramente evoluir para CPF+frase (ex.: CPF + "DLy-2025!").

WINDOWS (7-Zip)
---------------
1) Instale o 7-Zip (https://www.7-zip.org/) e garanta que '7z' esta no PATH.
2) Para criptografar:
   encrypt_alignment_windows.bat encrypt AIGAR_alignment_boot.jsonl
   -> Saida: AIGAR_alignment_boot.jsonl.7z (AES-256, headers ocultos -mhe)
3) Para descriptografar:
   encrypt_alignment_windows.bat decrypt AIGAR_alignment_boot.jsonl.7z

LINUX/macOS (OpenSSL)
---------------------
1) Certifique-se de ter 'openssl' instalado.
2) Para criptografar:
   ./encrypt_alignment_linux.sh encrypt AIGAR_alignment_boot.jsonl
   -> Saida: AIGAR_alignment_boot.jsonl.enc
3) Para descriptografar:
   ./encrypt_alignment_linux.sh decrypt AIGAR_alignment_boot.jsonl.enc

DICA
----
- Guarde a versao criptografada fora do computador principal (pendrive).
- Nunca salve a senha em texto puro dentro da pasta.
- Se trocar o runner do AIGAR, gere novos hashes e guarde-os separados.
