#!/usr/bin/env bash
# Pierwsze wdrożenie: usługa jeszcze nie istnieje, stąd "|| true".
systemctl stop nforum 2>/dev/null || true
exit 0