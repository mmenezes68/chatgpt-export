#!/usr/bin/env bash
set -euo pipefail
# Uso:
#   gera_relatorio.sh --obra CAMINHO_OBRA --capitulos "Cap1[,Cap2,...]" \
#                     --title "TÍTULO" --author "Autor" --advisor "Orientador" \
#                     --out /caminho/saida.pdf
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
exec "$BASE_DIR/bin/relatorio_full.sh" "$@"
