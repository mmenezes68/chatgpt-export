#!/usr/bin/env bash
set -euo pipefail
ATAS_DIR="docs/atas"
OUT="$ATAS_DIR/README.md"

# lista e ordena numericamente por sufixo ata_XXX.md
FILES=$(ls -1 "$ATAS_DIR"/ata_*.md 2>/dev/null | sed -E 's/.*ata_([0-9]+)\.md/\1 &/' | sort -n | awk '{print $2}')

{
  echo "# Índice de Atas"
  echo
  printf "| N° | Título | Data | Arquivo |\n|---:|---|:---:|:---|\n"
  for f in $FILES; do
    num=$(echo "$f" | sed -E 's/.*ata_([0-9]+)\.md/\1/')
    titulo=$(grep -m1 -E '^# ' "$f" | sed 's/^# *//; s/^"//; s/"$//')
    data=$(grep -m1 -E '^\*\*Data:\*\*|^Data:' "$f" 2>/dev/null \
           | sed -E 's/^\*\*Data:\*\* *//; s/^Data: *//; s/"//g')
    [ -z "${data:-}" ] && data="—"
    arq=$(basename "$f")
    printf '| %d | %s | %s | [%s](%s) |\n' "$((10#$num))" "$titulo" "$data" "$arq" "$arq"
  done
} > "$OUT"
echo "OK: $OUT"

cp docs/atas/README.md docs/atas/INDEX.md
