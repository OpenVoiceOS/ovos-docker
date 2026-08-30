#!/usr/bin/env bash
# Runtime smoke test, executed inside a freshly built image (docker run … --entrypoint /bin/bash -s < smoke.sh).
# Proves the image can actually start: interpreter present, installed packages consistent, entrypoint
# script parses, the service binary it execs exists, the readiness probe's dependency imports.
set -euo pipefail

if ! command -v python > /dev/null; then
  echo "no python interpreter: not a Python image, nothing to check"
  exit 0
fi
python -V
pip check
python -c "import websocket"   # ovos-hc (HEALTHCHECK) dependency

for f in /usr/local/bin/entrypoint.sh /usr/local/bin/skill-entrypoint.sh; do
  if [ -f "$f" ]; then
    bash -n "$f"
    echo "$f: syntax ok"
    bin=$(grep -oE '^exec [A-Za-z0-9_./-]+' "$f" | tail -1 | awk '{print $2}' || true)
    if [ -n "${bin:-}" ] && [ "$bin" != '"$@"' ]; then command -v "$bin" > /dev/null; echo "$f execs $bin: found"; fi
  fi
done

if [ -n "${SKILL_ID:-}" ]; then
  command -v ovos-skill-launcher > /dev/null
  python -c "import ovos_workshop, ovos_bus_client"
  echo "skill ${SKILL_ID}: launcher and workshop present"
fi
if [ -n "${SMOKE_BIN:-}" ]; then
  command -v "$SMOKE_BIN" > /dev/null
  echo "entrypoint binary ${SMOKE_BIN}: found"
fi
echo "smoke ok"
