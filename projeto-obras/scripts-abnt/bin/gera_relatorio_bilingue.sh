#!/usr/bin/env bash
set -euo pipefail

BASE="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$HOME}"

TITLE_PT="${TITLE_PT:-Relatório de Leitura — (PT)}"
TITLE_EN="${TITLE_EN:-Reading Report — (EN)}"

ARGS=("$@")

"$BASE/bin/gera_relatorio.sh" "${ARGS[@]}" \
  --title "$TITLE_PT" \
  --out "$OUT_DIR/Relatorio_PT.pdf"

"$BASE/bin/gera_relatorio.sh" "${ARGS[@]}" \
  --title "$TITLE_EN" \
  --out "$OUT_DIR/Report_EN.pdf"

echo "OK: relatórios gerados em $OUT_DIR/Relatorio_PT.pdf e $OUT_DIR/Report_EN.pdf"
