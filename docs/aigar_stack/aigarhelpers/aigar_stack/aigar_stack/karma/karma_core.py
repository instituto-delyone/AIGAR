import os, time, json, hashlib, subprocess, sys, datetime, pathlib, yaml

HERE = pathlib.Path(__file__).resolve().parent
CFG = yaml.safe_load(open(HERE/"config.yaml","r",encoding="utf-8"))
INBOX = (HERE/CFG["inbox"]).resolve()
OUTBOX = (HERE/CFG["outbox"]).resolve()
LOGF = (HERE/CFG["log_file"]).resolve()
HASHES = (HERE/CFG["security"]["hashes_file"]).resolve()
VERIFY = bool(CFG["security"]["verify_hashes"])
RUNNER = (HERE/CFG["aigar"]["runner"]).resolve()
TIMEOUT = int(CFG["aigar"]["timeout_sec"])

INBOX.mkdir(parents=True, exist_ok=True)
OUTBOX.mkdir(parents=True, exist_ok=True)
LOGF.parent.mkdir(parents=True, exist_ok=True)

def log(msg):
    ts = datetime.datetime.now().isoformat(timespec="seconds")
    with open(LOGF,"a",encoding="utf-8") as f:
        f.write(f"[{ts}] {msg}\n")

def sha256_file(p):
    h = hashlib.sha256()
    with open(p,"rb") as f:
        for ch in iter(lambda: f.read(1<<20), b""):
            h.update(ch)
    return h.hexdigest()

def verify_hashes():
    if not VERIFY:
        log("hash-verify: skipped")
        return True
    if not HASHES.exists():
        log("hash-verify: no hashes.txt — FAIL")
        return False
    expected = {}
    with open(HASHES,"r",encoding="utf-8") as f:
        for line in f:
            line=line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split()
            if len(parts)>=2:
                expected[" ".join(parts[1:]).lstrip("*")] = parts[0]
    for rel,hexv in expected.items():
        p = (HERE/rel).resolve()
        if not p.exists():
            log(f"hash-verify: missing {rel} — FAIL")
            return False
        cur = sha256_file(p)
        if cur.lower()!=hexv.lower():
            log(f"hash-verify: mismatch {rel} — FAIL")
            return False
    log("hash-verify: OK")
    return True

def call_aigar(payload):
    try:
        proc = subprocess.run(
            [sys.executable, str(RUNNER)],
            input=json.dumps(payload).encode("utf-8"),
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            timeout=TIMEOUT
        )
        if proc.returncode!=0:
            return {"error": f"aigar runner rc={proc.returncode}", "stderr": proc.stderr.decode("utf-8","ignore")}
        out = proc.stdout.decode("utf-8","ignore").strip()
        return json.loads(out)
    except subprocess.TimeoutExpired:
        return {"error":"timeout"}
    except Exception as e:
        return {"error": f"exception {e}"}

def process_file(fp):
    with open(fp,"r",encoding="utf-8") as f:
        for line in f:
            line=line.strip()
            if not line:
                continue
            req = json.loads(line)
            rid = req.get("id") or f"req-{int(time.time()*1000)}"
            res = call_aigar(req)
            out = {"id": rid, "karma_ts": int(time.time()), "response": res}
            with open(OUTBOX/f"{rid}.json","w",encoding="utf-8") as g:
                json.dump(out,g,ensure_ascii=False)
    os.remove(fp)

def main():
    log("Karma booting…")
    if CFG["security"].get("offline_only", True):
        os.environ["NO_NET"]="1"
    if not verify_hashes():
        log("ABORT: hash verification failed.")
        return
    log("Watching inbox…")
    while True:
        for name in sorted(os.listdir(INBOX)):
            if not name.endswith(".jsonl"):
                continue
            process_file(INBOX/name)
        time.sleep(0.4)

if __name__=="__main__":
    main()
