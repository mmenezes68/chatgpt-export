#!/usr/bin/env bash
# Normaliza todos os .md para UTF-8 (remove latin1/macroman/etc)
# Uso: ./normalize_utf8.sh <diretorio-da-obra>

set -euo pipefail

DIR="${1:-}"
if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
  echo "Uso: $0 <diretorio-da-obra>"
  exit 1
fi

find "$DIR" -type f -name '*.md' | while read -r f; do
  echo "→ Normalizando: $f"
  # converte detectando charset e reescrevendo em UTF-8
  iconv -f UTF-8 -t UTF-8 "$f" >/dev/null 2>&1 && continue
  enca -L none "$f" >/dev/null 2>&1 || true
  # tenta iso-8859-1 como fallback
  iconv -f ISO-8859-1 -t UTF-8 "$f" -o "$f.utf8" 2>/dev/null || cp "$f" "$f.utf8"
  mv "$f.utf8" "$f"
done

echo "✅ Todos os .md normalizados para UTF-8."
