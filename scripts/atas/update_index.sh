#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-$HOME/chatgpt-export}"
ATAS_DIR="$REPO/docs/atas"
INDEX="$ATAS_DIR/INDEX.md"

cd "$REPO"
mkdir -p "$ATAS_DIR"

# 1) Backlink no topo de cada ata
backlink='[⬅︎ Voltar ao índice](./INDEX.md)'
shopt -s nullglob
for f in "$ATAS_DIR"/ata_[0-9][0-9][0-9].md; do
  if ! head -n 5 "$f" | grep -qF "$backlink"; then
    tmp="$(mktemp)"
    { printf '%s\n\n' "$backlink"; cat "$f"; } > "$tmp"
    mv "$tmp" "$f"
    echo "Backlink inserido: $(basename "$f")"
  fi
done
shopt -u nullglob

# 2) Gerar INDEX.md
{
  echo "# Índice de Atas"
  echo
  echo "| Nº | Título | Data | Arquivo |"
  echo "|---:|---|---|---|"

  {
    shopt -s nullglob
    for f in "$ATAS_DIR"/ata_[0-9][0-9][0-9].md; do
      base="$(basename "$f")"
      nraw="${base#ata_}"; nraw="${nraw%.md}"
      num=$((10#$nraw))

      title="$(grep -m1 -E '^# ' "$f" | sed 's/^#\s*//;s/|/-/g')"
      [ -n "$title" ] || title="$base"

      date="$(grep -im1 '^data:' "$f" | sed 's/^[Dd]ata:\s*//;s/|/-/g')"
      [ -n "$date" ] || date="—"

      printf '%05d\t| %d | %s | %s | [%s](./%s) |\n' \
        "$num" "$num" "$title" "$date" "$base" "$base"
    done
    shopt -u nullglob
  } | sort -n -k1,1 | cut -f2-
} > "$INDEX"

# 3) Commit se houver mudanças
if ! git diff --quiet -- "$ATAS_DIR"; then
  git add "$ATAS_DIR"
  git commit -m "docs(atas): backlinks e INDEX.md regenerado"
  echo "✔ Commit criado."
else
  echo "ℹ Nenhuma mudança a commitar."
fi
