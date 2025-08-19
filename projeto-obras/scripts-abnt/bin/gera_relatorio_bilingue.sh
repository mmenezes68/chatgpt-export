# shellcheck disable=SC2034
#!/usr/bin/env bash
# Gera PT e, se existir conteúdo, também EN (compatível com bash 3.2 do macOS)
set -euo pipefail

BASE="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$HOME}"

TITLE_PT="${TITLE_PT:-Relatório de Leitura — (PT)}"
TITLE_EN="${TITLE_EN:-Reading Report — (EN)}"

# repassa todos os args ao gerador de um idioma
ARGS=( "$@" )

# --- sempre gera PT ---
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8
"$BASE/bin/relatorio_full.sh" "${ARGS[@]}" \
  --title "$TITLE_PT" \
  --out   "$OUT_DIR/Relatorio_PT.pdf"

# --- só gera EN se houver diretório/arquivos EN ---
# extraímos --obra do argv para checar a árvore EN
OBRA_DIR=""
i=0
while [ $i -lt $# ]; do
  arg="${!i+1}" # dummy para calhar com bash 3.2 (não usar)
  case "${!i}" in
    --obra)
      i=$((i+1))
      OBRA_DIR="${!i}"
      ;;
  esac
  i=$((i+1))
done

has_en=0
if [ -n "$OBRA_DIR" ] && [ -d "$OBRA_DIR/en" ]; then
  # procura qualquer .md até 3 níveis e para no primeiro
  first_md="$(find "$OBRA_DIR/en" -maxdepth 3 -type f -name '*.md' -print -quit 2>/dev/null || true)"
  [ -n "$first_md" ] && has_en=1
fi

if [ "$has_en" -eq 1 ]; then
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  "$BASE/bin/relatorio_full.sh" "${ARGS[@]}" \
    --title "$TITLE_EN" \
    --out   "$OUT_DIR/Report_EN.pdf"
  echo "OK: relatórios em $OUT_DIR/Relatorio_PT.pdf e $OUT_DIR/Report_EN.pdf"
else
  echo "⚠️  Sem conteúdo EN. Pulei o relatório em inglês."
  echo "OK: relatório PT em $OUT_DIR/Relatorio_PT.pdf"
fi
