# Opcional: ponte somente se o AIGAR exigir formatação diferente.
# Se seu aigar_cli.py já aceita JSON via stdin, pode ignorar este arquivo.

import sys, json

def run():
    payload = json.loads(sys.stdin.read())
    prompt = payload.get("text","")
    # Simulação de transformação:
    answer = f"[AIGAR] {prompt[:200]}"
    out = {"text": answer, "meta": {"tokens": len(prompt.split())}}
    print(json.dumps(out, ensure_ascii=False))

if __name__=="__main__":
    run()
