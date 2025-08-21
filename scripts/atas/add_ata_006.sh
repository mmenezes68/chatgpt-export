#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/chatgpt-export"
SRC="$HOME/Downloads/ata_006.md"
ATAS_DIR="$REPO/docs/atas"
DEST="$ATAS_DIR/ata_006.md"
INDEX="$ATAS_DIR/INDEX.md"

[[ -f "$SRC" ]] || { echo "❌ Arquivo não encontrado: $SRC"; exit 1; }
mkdir -p "$ATAS_DIR"

# mover com backup se já existir
if [[ -f "$DEST" ]]; then
  ts="$(date +%Y%m%d-%H%M%S)"
  cp "$DEST" "${DEST}.bak-$ts"
fi
mv -f "$SRC" "$DEST"

# backlink no topo
if ! grep -q 'INDEX.md' "$DEST"; then
  tmp="$(mktemp)"
  { echo "[⬅ Voltar ao índice](./INDEX.md)"; echo; cat "$DEST"; } > "$tmp"
  mv "$tmp" "$DEST"
fi

# regenerar INDEX.md (ordenado numericamente)
{
  echo "# Índice de Atas"
  echo
  echo "| Nº | Título | Data | Arquivo |"
  echo "|---:|---|---|---|"

  find "$ATAS_DIR" -maxdepth 1 -type f -name 'ata_[0-9][0-9][0-9].md' -print0 \
  | sort -z \
  | while IFS= read -r -d '' f; do
      base="$(basename "$f")"
      num="$(sed -E 's/ata_0*([0-9]+)\.md/\1/' <<<"$base")"
      title="$(grep -m1 -E '^# ' "$f" | sed 's/^#\s*//')"
      [[ -n "$title" ]] || title="$base"
      date="$(grep -im1 '^data:' "$f" | sed 's/^[Dd]ata:\s*//')"
      [[ -n "$date" ]] || date="—"
      printf '%05d\t| %s | %s | %s | [%s](./%s) |\n' "$num" "$num" "$title" "$date" "$base" "$base"
    done | sort -n -k1,1 | cut -f2-
} > "$INDEX"

cd "$REPO"
git add "docs/atas/ata_006.md" "docs/atas/INDEX.md"
git commit -m "docs(atas): adicionar ata_006, inserir backlink e atualizar INDEX.md" || true
git push origin main
