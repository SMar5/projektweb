#!/usr/bin/env bash
set -euo pipefail
for i in $(seq 1 20); do
  if curl -fsS http://127.0.0.1:8000/health/ >/dev/null; then
    echo "OK: aplikacja odpowiada"
    exit 0
  fi
  sleep 3
done
echo "BLAD: /health/ nie odpowiada po 60 s" >&2
journalctl -u nforum -n 50 --no-pager >&2 || true
exit 1