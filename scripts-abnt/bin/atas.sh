#!/usr/bin/env bash
set -euo pipefail

ATAS_DIR="docs/atas"
INDEXER="scripts-abnt/bin/build_index_atas.sh"

cmd="${1:-}"; shift || true
case "$cmd" in
  new)
    modelo="$ATAS_DIR/_modelo_ata.md"
    [[ -f "$modelo" ]] || { echo "Modelo não encontrado: $modelo"; exit 1; }
    ultimo=$(ls -1 "$ATAS_DIR"/ata_*.md 2>/dev/null | sed -E 's/.*ata_([0-9]+)\.md/\1/' | sort -n | tail -1)
    ultimo=${ultimo:-0}; novo=$(printf "%03d" $((10#$ultimo + 1)))
    dest="$ATAS_DIR/ata_${novo}.md"
    sed "s/NNN/${novo}/; s/YYYY-MM-DD/$(date +%F)/" "$modelo" > "$dest"
    echo "Criada: $dest"
    ${EDITOR:-vi} "$dest"
    ;;
  index)
    bash "$INDEXER"
    cp "$ATAS_DIR/README.md" "$ATAS_DIR/INDEX.md"
    ;;
  fix)
    bash scripts-abnt/bin/normalize_atas.sh
    bash scripts-abnt/bin/lint_atas.sh || true
    ;;
  commit)
    msg="${1:-Atualiza atas}"
    git add "$ATAS_DIR" scripts-abnt/bin/*.sh
    git commit -m "$msg"
    ;;
  push)
    git push
    ;;
  *)
    echo "uso: bash scripts-abnt/bin/atas.sh {new|index|fix|commit|push}"
    exit 1
    ;;
esac
