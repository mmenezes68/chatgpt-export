#!/usr/bin/env bash
set -euo pipefail

ATAS="docs/atas"
modelo="$ATAS/_modelo_ata.md"
[[ -f "$modelo" ]] || { echo "Modelo não encontrado: $modelo"; exit 1; }

# pega último número (decimal)
ultimo=$(ls -1 "$ATAS"/ata_*.md 2>/dev/null | sed -E 's/.*ata_([0-9]+)\.md/\1/' | sort -n | tail -1)
ultimo=${ultimo:-0}

# força base 10 e incrementa
novo_num=$((10#$ultimo + 1))
novo=$(printf "%03d" "$novo_num")
dest="$ATAS/ata_${novo}.md"

# instancia pelo modelo
sed "s/NNN/${novo}/; s/YYYY-MM-DD/$(date +%F)/" "$modelo" > "$dest"
echo "Criada: $dest"
