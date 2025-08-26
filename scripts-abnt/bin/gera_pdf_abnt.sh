#!/usr/bin/env bash
set -euo pipefail
lang="${1:-}"; [[ "$lang" =~ ^(pt|en)$ ]] || { echo "uso: $0 {pt|en} [/caminho/da/obra]"; exit 1; }
ROOT="${2:-01_The_Character_of_Consciousness}"
IN="$ROOT/01_The_Character_of_Consciousness_${lang}.md"
mkdir -p "$ROOT/Relatorio_ABNT"
lang_uc=$(printf '%s' "$lang" | tr '[:lower:]' '[:upper:]')
OUT="$ROOT/Relatorio_ABNT/Relatorio_ABNT_${lang_uc}.pdf"
tmpl="scripts-abnt/templates/relatorio-abnt-usp.tex"
mainfont="${MAINFONT:-DejaVu Serif}"

"$(dirname "$0")/preflight_md.sh" "$IN"

TEXINPUTS="$(pwd)/scripts-abnt/templates:" \
pandoc "$IN" --from=gfm --pdf-engine=xelatex \
  --template "$tmpl" -V mainfont="$mainfont" -o "$OUT"
echo "OK: $OUT"
