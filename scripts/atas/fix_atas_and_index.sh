#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-$HOME/chatgpt-export}"
ATAS_DIR="$REPO/docs/atas"
INDEX="$ATAS_DIR/INDEX.md"

mkdir -p "$ATAS_DIR"

# 1) Normaliza nomes: ATA_###.md -> ata_###.md
for f in "$ATAS_DIR"/ATA_[0-9][0-9][0-9].md; do
  [ -e "$f" ] || continue
  mv -f "$f" "${f/ATA_/ata_}"
done

# 2) Backlink no topo (se não houver)
for f in "$ATAS_DIR"/ata_[0-9][0-9][0-9].md; do
  [ -e "$f" ] || continue
  if ! grep -qE '^\[← Voltar ao índice\]\(\./INDEX\.md\)' "$f"; then
    tmp=$(mktemp)
    printf '[← Voltar ao índice](./INDEX.md)\n\n' > "$tmp"
    cat "$f" >> "$tmp"
    mv "$tmp" "$f"
  fi
done

# 3) Gerar INDEX.md ordenado numericamente
{
  printf '# Índice de Atas\n\n| Nº | Título | Data | Arquivo |\n|---:|---|---|---|\n'
  tmp_lines=$(mktemp)
  find "$ATAS_DIR" -maxdepth 1 -type f -name 'ata_[0-9][0-9][0-9].md' -print0 \
  | while IFS= read -r -d '' f; do
      base=$(basename "$f")
      num=$(printf '%s' "$base" | sed -E 's/^ata_0*([0-9]+)\.md/\1/')
      title=$(grep -m1 -E '^# ' "$f" | sed 's/^# *//')
      [ -n "$title" ] || title="$base"
      date=$(grep -im1 '^data:' "$f" | sed 's/^[Dd]ata: *//')
      [ -n "$date" ] || date=—
      printf '%05d\t| %s | %s | %s | [%s](./%s) |\n' \
        "$num" "$num" "$title" "$date" "$base" "$base" >> "$tmp_lines"
    done
  LC_ALL=C sort -n -k1,1 "$tmp_lines" | cut -f2-
  rm -f "$tmp_lines"
} > "$INDEX"

echo "🗂  Gerado: $INDEX"

# 4) Commit + push se houver mudanças
cd "$REPO"
git add docs/atas/ata_*.md docs/atas/INDEX.md || true
if ! git diff --cached --quiet; then
  git commit -m "docs(atas): normaliza nomes, adiciona backlinks e atualiza INDEX.md"
  git push origin main
  echo "✅ Commit e push."
else
  echo "ℹ️  Nada a commitar."
fi
