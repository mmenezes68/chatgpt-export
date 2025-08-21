#!/usr/bin/env bash
set -euo pipefail

ATAS="docs/atas"
INDEX="$ATAS/INDEX.md"

{
  echo "# Índice de Atas"
  echo
  echo "| Nº | Título | Data | Arquivo |"
  echo "|---:|---|---|---|"

  # lista ata_###.md em ordem numérica
  while IFS= read -r -d '' f; do
    base="$(basename "$f")"
    num="$(printf "%s" "$base" | sed -E 's/^ata_0*([0-9]+)\.md/\1/')"

    # Título: primeira linha "# ..." ou "Título: ...", ignorando o backlink
    title="$(
      awk '
        BEGIN{IGNORECASE=1}
        /^\[← *Voltar ao índice\]\(.*\)/{next}
        /^#[[:space:]]+/ { sub(/^#[[:space:]]+/, "", $0); print; exit }
        /^[[:space:]]*t[íi]tulo:[[:space:]]*/ { sub(/^[[:space:]]*[Tt][íi]tulo:[[:space:]]*/, "", $0); print; exit }
      ' "$f"
    )"
    [ -n "$title" ] || title="$base"

    # Data: "Data: ..."
    date="$(grep -im1 '^data:' "$f" | sed 's/^[Dd]ata:[[:space:]]*//')"
    [ -n "$date" ] || date="—"

    printf '| %s | %s | %s | [%s](./%s) |\n' "$num" "$title" "$date" "$base" "$base"
  done < <(find "$ATAS" -maxdepth 1 -type f -name 'ata_[0-9][0-9][0-9].md' -print0 | LC_ALL=C sort -z)
} > "$INDEX"

echo "🗂  Gerado: $INDEX"
