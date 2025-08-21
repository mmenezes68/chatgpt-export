#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-$HOME/chatgpt-export}"
ATAS_DIR="$REPO/docs/atas"
INDEX="$ATAS_DIR/INDEX.md"

mkdir -p "$ATAS_DIR"

# === mover ATA_005.md se estiver fora do lugar ===
candidates=(
  "$REPO/atas/ATA_005.md"
  "$REPO/atas/ata_005.md"
  "$REPO/ATA_005.md"
  "$REPO/ata_005.md"
  "$HOME/Downloads/ATA_005.md"
  "$HOME/Downloads/ata_005.md"
)
for SRC in "${candidates[@]}"; do
  if [[ -f "$SRC" ]]; then
    echo "Movendo: $SRC -> $ATAS_DIR/ATA_005.md"
    mv -f "$SRC" "$ATAS_DIR/ATA_005.md"
    break
  fi
done

cd "$REPO"

# === gerar índice ===
{
  echo "# Índice de ATAs"
  echo
  echo "_Gerado em $(date '+%Y-%m-%d %H:%M:%S')_"
  echo
  echo "| Nº | Título | Data | Caminho |"
  echo "|---:|--------|------|---------|"

  ls -1 "$ATAS_DIR"/*.md 2>/dev/null | grep -v '/INDEX.md$' | sort -V | while read -r f; do
    base="$(basename "$f")"
    # nº (tenta extrair 001… do nome)
    num="$(echo "$base" | grep -Eo '[0-9]+' | head -1 || true)"
    [[ -z "${num:-}" ]] && num="—"
    # título = primeira linha "# "
    title="$(grep -m1 -E '^# ' "$f" | sed 's/^#\s*//' || true)"
    [[ -z "${title:-}" ]] && title="$base"
    # data = linha que começa com "Data:"
    date="$(grep -im1 '^data:' "$f" | sed 's/^[Dd]ata:\s*//' || true)"
    [[ -z "${date:-}" ]] && date="—"
    rel="docs/atas/$base"
    echo "| $num | $title | $date | [$base]($rel) |"
  done
} > "$INDEX"

# === commit + push ===
git add "$ATAS_DIR/ATA_005.md" 2>/dev/null || true
git add "$INDEX"
git commit -m "docs(atas): mover ATA_005 p/ docs/atas e criar/atualizar INDEX.md" || echo "Nada para commitar."
git push origin main
