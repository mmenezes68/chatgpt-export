#!/usr/bin/env bash
set -euo pipefail
[ $# -eq 1 ] || { echo "uso: $0 Nome_da_Obra"; exit 2; }
OBRA="projeto-obras/obras/$1"
mkdir -p "$OBRA/raw"
mkdir -p "$OBRA/pt/00_front-matter" "$OBRA/pt/01_capitulos" "$OBRA/pt/02_notas" "$OBRA/pt/99_back-matter"
mkdir -p "$OBRA/en/00_front-matter" "$OBRA/en/01_chapters"  "$OBRA/en/02_notes" "$OBRA/en/99_back-matter"

cat > "$OBRA/pt/00_front-matter/Resumo.md" <<'MD'
# Resumo
> (Escreva aqui um resumo conciso do relatório em português — ~150–250 palavras.)
**Palavras-chave:** …
MD

cat > "$OBRA/en/00_front-matter/Abstract.md" <<'MD'
# Abstract
> (Write here a concise abstract in English — ~150–250 words.)
**Keywords:** …
MD

echo "OK: esqueleto criado em $OBRA"
