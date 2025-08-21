#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
IN_MD="$ROOT_DIR/docs/modelo_relatorio_abnt.md"
OUT_PDF="$ROOT_DIR/docs/modelo_relatorio_abnt.pdf"
TEMPL_DIR="$ROOT_DIR/projeto-obras/scripts-abnt/templates"

HDR=""
if [ -f "$TEMPL_DIR/abnt_header.tex" ]; then
  HDR="$TEMPL_DIR/abnt_header.tex"
elif [ -f "$TEMPL_DIR/abnt-header.tex" ]; then
  HDR="$TEMPL_DIR/abnt-header.tex"
else
  echo "ERRO: não encontrei abnt_header.tex/abnt-header.tex em $TEMPL_DIR" >&2
  exit 1
fi

echo "▶️ Gerando PDF de teste..."
pandoc "$IN_MD" \
  -o "$OUT_PDF" \
  --pdf-engine=xelatex \
  -H "$HDR" \
  -V mainfont="Times New Roman"

echo "✅ PDF gerado em: $OUT_PDF"
