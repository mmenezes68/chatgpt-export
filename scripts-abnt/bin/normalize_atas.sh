#!/usr/bin/env bash
set -euo pipefail
for f in docs/atas/ata_*.md; do
  tmp="$f.tmp"
  sed -E \
    -e '1s/^# +"?/# /' \
    -e '1s/"$//' \
    -e 's/^("?Data:"?)/**Data:**/g' \
    -e 's/^\*\*Data:\*\* *$/**Data:** —/g' \
    "$f" > "$tmp" && mv "$tmp" "$f"
  echo "Normalizado: $f"
done
