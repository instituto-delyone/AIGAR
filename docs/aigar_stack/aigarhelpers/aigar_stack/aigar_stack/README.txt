
AIGAR_STACK — Karma + AIGAR (offline)

Estrutura:
  AIGAR_STACK/
    karma/
      karma_core.py
      aigar_bridge.py (opcional)
      config.yaml
      hashes.txt
    aigar/
      aigar_cli.py (placeholder — troque pelo seu runner real)
      model/
    io/
      inbox/   (solicitações .jsonl)
      outbox/  (respostas .json)
    logs/

Como usar (Linux/macOS):
  1) cd AIGAR_STACK/karma
  2) python3 karma_core.py
  3) Em outro terminal: ecoe uma linha JSON para ../io/inbox/teste.jsonl
     Ex.: echo '{"id":"teste-001","role":"user","text":"Explique o plano em 3 bullets."}' >> ../io/inbox/teste.jsonl
  4) Veja a resposta em ../io/outbox/teste-001.json

Como usar (Windows PowerShell):
  1) cd AIGAR_STACK\karma
  2) py .\karma_core.py
  3) New-Item -ItemType File ..\io\inbox\teste.jsonl -Force
     Add-Content ..\io\inbox\teste.jsonl '{"id":"teste-001","role":"user","text":"Explique o plano em 3 bullets."}'
  4) Abra ..\io\outbox\teste-001.json

Hashes (integridade):
  - O Karma verifica hashes em boot.
  - hashes.txt usa caminhos RELATIVOS ao diretório AIGAR_STACK/karma.
    Exemplos válidos:
      *karma_core.py
      *aigar_bridge.py
      *../aigar/aigar_cli.py
  - Para recalcular:
      Linux/macOS:  shasum -a 256 FILE
      Windows:      CertUtil -hashfile FILE SHA256
  - Para verificar manualmente (Linux/macOS):
      shasum -a 256 -c hashes.txt

Observação:
  - Este pacote vem com um runner de AIGAR de exemplo (aigar_cli.py) apenas para teste.
    Substitua-o pelo seu binário/script real quando quiser.

Gerado em: 2025-08-26T21:36:42
