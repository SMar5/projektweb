#!/usr/bin/env bash
set -euo pipefail
# Stara usługa gunicorna z poprzedniego sposobu wdrażania (git pull).
# ZMIEŃ nazwę na faktyczną albo usuń linię, jeśli takiej usługi nie ma.
LEGACY_UNIT="gunicorn"
systemctl disable --now "${LEGACY_UNIT}.service" 2>/dev/null || true
id nforum &>/dev/null || useradd --system --home-dir /opt/nforum --shell /sbin/nologin nforum
mkdir -p /opt/nforum
rm -rf /opt/nforum/current