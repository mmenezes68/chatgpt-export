#!/usr/bin/env bash
set -euo pipefail
ATAS="docs/atas"
req=("^# Ata [0-9]{3} — " "^\\*\\*Data:\\*\\*" "^## 1\\. Contexto$" "^## 2\\. Decisões$" "^## 3\\. Ações" "^## 4\\. Anexos")
status=0
for f in "$ATAS"/ata_*.md; do
  [[ -f "$f" ]] || continue
  missing=()
  for r in "${req[@]}"; do
    grep -Eq "$r" "$f" || missing+=("$r")
  done
  if ((${#missing[@]})); then
    echo "❌ $f faltando:"
    printf '   - %s\n' "${missing[@]}"
    status=1
  else
    echo "✅ $f OK"
  fi
done
exit $status
