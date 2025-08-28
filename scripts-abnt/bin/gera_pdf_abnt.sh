#!/usr/bin/env bash
set -euo pipefail

lang="${1:-}"; [[ "$lang" =~ ^(pt|en)$ ]] || { 
  echo "uso: $0 {pt|en} [/caminho/da/obra]"; 
  exit 1; 
}

ROOT="${2:-01_The_Character_of_Consciousness}"
IN="$ROOT/01_The_Character_of_Consciousness_${lang}.md"
mkdir -p "$ROOT/Relatorio_ABNT"

# upper-case para sufixo
lang_uc=$(printf '%s' "$lang" | tr '[:lower:]' '[:upper:]')
OUT="$ROOT/Relatorio_ABNT/Relatorio_ABNT_${lang_uc}.pdf"

tmpl="scripts-abnt/templates/relatorio-abnt-usp.tex"
mainfont="${MAINFONT:-DejaVu Serif}"

# Passo 1: saneamento de caracteres problemáticos
"$(dirname "$0")/preflight_md.sh" "$IN"

# Passo 2: sanitização de cabeçalhos
"$(dirname "$0")/sanitize_md.sh" "$IN"

# Passo 3: compilação com pandoc + xelatex
TEXINPUTS="$(pwd)/scripts-abnt/templates:" \
pandoc "$IN" --from=gfm --pdf-engine=xelatex \
  --template "$tmpl" \
  \
  -o "$OUT"

echo "OK: $OUT"
