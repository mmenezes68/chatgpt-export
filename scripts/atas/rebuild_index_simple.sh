#!/usr/bin/env bash
set -euo pipefail

ATAS="docs/atas"
INDEX="$ATAS/INDEX.md"

{
  echo "# Índice de Atas"
  echo
  echo "| Nº | Título | Data | Arquivo |"
  echo "|---:|---|---|---|"

  # lista estável, ordenada numericamente por sufixo
  for f in $(ls "$ATAS"/ata_[0-9][0-9][0-9].md 2>/dev/null | LC_ALL=C sort); do
    base="${f##*/}"                    # ata_00X.md
    num="${base#ata_}"; num="${num%.md}"
    num="$((10#$num))"                 # remove zeros à esquerda

    # título: primeira linha que seja "# ..." ou "Título: ..."
    title="$(grep -m1 -E '^# |^[Tt][íi]tulo:' "$f" \
             | sed -E 's/^# *//; s/^[Tt][íi]tulo:\s*//')"
    [ -n "$title" ] || title="$base"

    # data: linha "Data: ..."
    date="$(grep -im1 '^data:' "$f" | sed -E 's/^[Dd]ata:\s*//')"
    [ -n "$date" ] || date="—"

    printf '| %s | %s | %s | [%s](./%s) |\n' "$num" "$title" "$date" "$base" "$base"
  done
} > "$INDEX"

git add "$INDEX"
git commit -m "docs(atas): regenerar INDEX.md (script simples)" || true
git push origin main || true
