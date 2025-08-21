#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-$HOME/chatgpt-export}"
ATAS_DIR="$REPO/docs/atas"
INDEX="$ATAS_DIR/INDEX.md"

cd "$REPO"

# === Renomear se necessário ===
if [[ -f "$ATAS_DIR/ATA_005.md" ]]; then
  echo "Renomeando ATA_005.md -> ata_005.md"
  mv "$ATAS_DIR/ATA_005.md" "$ATAS_DIR/ata_005.md"
fi

# === Regerar índice ===
{
  echo "# Índice de ATAs"
  echo
  echo "_Gerado em $(date '+%Y-%m-%d %H:%M:%S')_"
  echo
  echo "| Nº | Título | Data | Caminho |"
  echo "|---:|--------|------|---------|"

  ls -1 "$ATAS_DIR"/ata_*.md 2>/dev/null | grep -v '/INDEX.md$' | sort -V | while read -r f; do
    base="$(basename "$f")"
    num="$(echo "$base" | grep -Eo '[0-9]+' | head -1 || true)"
    [[ -z "${num:-}" ]] && num="—"
    title="$(grep -m1 -E '^# ' "$f" | sed 's/^#\s*//' || true)"
    [[ -z "${title:-}" ]] && title="$base"
    date="$(grep -im1 '^data:' "$f" | sed 's/^[Dd]ata:\s*//' || true)"
    [[ -z "${date:-}" ]] && date="—"
    rel="docs/atas/$base"
    echo "| $num | $title | $date | [$base]($rel) |"
  done
} > "$INDEX"

# === Commit + push ===
git add "$ATAS_DIR/ata_005.md" 2>/dev/null || true
git add "$INDEX"
git commit -m "docs(atas): renomear ATA_005.md -> ata_005.md e atualizar INDEX.md" || echo "Nada para commitar."
git push origin main
