#!/usr/bin/env bash
set -euo pipefail
usage() {
  cat <<EOF
uso: $0 --obra CAMINHO_DA_OBRA --capitulos "PastaCap1[,PastaCap2...]" \\
         --title "Título" --author "Autor" --advisor "Orientador" --out /caminho/saida.pdf
opções:
  --city "Cidade"         (padrão: São Paulo)
  --instit "Instituição"  (padrão: USP — ICB)
  --date "DD/MM/AAAA"     (padrão: hoje)
EOF
}
OBRA=""; CAPITULOS=""; TITLE=""; AUTHOR=""; ADVISOR=""; OUT=""
CITY="São Paulo"; INSTIT="Universidade de São Paulo — Instituto de Ciências Biomédicas (ICB-USP)"
DATE="$(date +%d/%m/%Y)"
while [ $# -gt 0 ]; do
  case "$1" in
    --obra) OBRA="$2"; shift 2;;
    --capitulos) CAPITULOS="$2"; shift 2;;
    --title) TITLE="$2"; shift 2;;
    --author) AUTHOR="$2"; shift 2;;
    --advisor) ADVISOR="$2"; shift 2;;
    --city) CITY="$2"; shift 2;;
    --instit) INSTIT="$2"; shift 2;;
    --date) DATE="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "opção desconhecida: $1"; usage; exit 2;;
  esac
done
[ -n "$OBRA" ] && [ -n "$CAPITULOS" ] && [ -n "$TITLE" ] && [ -n "$AUTHOR" ] && [ -n "$ADVISOR" ] && [ -n "$OUT" ] || { usage; exit 2; }
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPL_DIR="$SCRIPT_DIR/../templates"
ABNT_HEADER="$TEMPL_DIR/abnt_header.tex"
ABNT_COVER="$TEMPL_DIR/abnt_cover.tex"
. "$SCRIPT_DIR/normalize_vars.sh"; normalize_vars
# coleta .md
INCLUDES=()
IFS=',' read -r CAPLIST <<< "$CAPITULOS"
for C in $CAPLIST; do
  C_DIR="$OBRA/$C"
  if [ ! -d "$C_DIR" ]; then echo "⚠️  Capítulo inexistente: $C_DIR"; continue; fi
  while IFS= read -r -d '' f; do INCLUDES+=("$f"); done < <(find "$C_DIR" -type f -name '*.md' -maxdepth 1 -print0 | sort -z)
done
[ "${#INCLUDES[@]}" -gt 0 ] || { echo "❌ Nenhum .md encontrado."; exit 1; }
# temporários
TMPDIR="$(mktemp -d /tmp/relatorio_XXXXXX)"; trap 'rm -rf "$TMPDIR"' EXIT
TMP_MD=()
for f in "${INCLUDES[@]}"; do b="$(basename "$f")"; cp -f "$f" "$TMPDIR/$b"; TMP_MD+=("$TMPDIR/$b"); done
"$SCRIPT_DIR/normalize_text.sh" "${TMP_MD[@]}"
# capa com variáveis
ABNT_COVER_TMP="$TMPDIR/cover.tex"
sed -e "s|\$TITLE|$TITLE|g" \
    -e "s|\$AUTHOR|$AUTHOR|g" \
    -e "s|\$ADVISOR|$ADVISOR|g" \
    -e "s|\$INSTIT|$INSTIT|g" \
    -e "s|\$CITY|$CITY|g" \
    -e "s|\$DATE|$DATE|g" "$ABNT_COVER" > "$ABNT_COVER_TMP"
# pandoc
LOG="${OUT%.pdf}.log"
echo "→ Arquivos incluídos:"; for f in "${TMP_MD[@]}"; do echo "   • $f"; done
echo "▶ Gerando PDF…"
if pandoc "${TMP_MD[@]}" \
  --from=markdown \
  --pdf-engine=xelatex \
  --toc --toc-depth=1 \
  --number-sections -V secnumdepth=1 \
  -V documentclass=article \
  --include-in-header="$ABNT_HEADER" \
  --include-before-body="$ABNT_COVER_TMP" \
  -o "$OUT" 2> "$LOG"; then
  echo "✅ PDF gerado em: $OUT"
else
  echo "❌ Erro na geração do PDF. Veja o log: $LOG"; exit 1
fi
