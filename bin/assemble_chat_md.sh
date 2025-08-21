#!/usr/bin/env bash
set -euo pipefail
DIR="docs/Caderno_Requisitos/_chunks"
OUT="docs/Caderno_Requisitos/chat_compilado.md"

if [ ! -d "$DIR" ]; then
  echo "Nada para montar (faltam chunks em $DIR)"
  exit 1
fi

cat > "$OUT" <<'MD'
# Caderno de Requisitos — Compilado do Chat

> Documento gerado a partir de trechos do chat (texto e código).
> Fonte: `docs/Caderno_Requisitos/_chunks/`

## Sumário
<!-- Gere o sumário no Typora/Obsidian -->
MD

# Concatena em ordem
for f in $(ls -1 "$DIR" | sort); do
  echo "" >> "$OUT"
  echo "<!-- ===== $(basename "$f") ===== -->" >> "$OUT"
  echo "" >> "$OUT"
  cat "$DIR/$f" >> "$OUT"
  echo "" >> "$OUT"
done

echo "✅ Gerado: $OUT"
