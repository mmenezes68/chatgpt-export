#!/bin/bash
# shellcheck disable=SC2020
#!/usr/bin/env bash
set -euo pipefail

# ============= Args =============
OBRA_DIR=""
CAP_DIR_NAME=""
TITLE="Relatório de Leitura"
AUTHOR=""
ADVISOR=""
OUT="$HOME/Relatorio_PT_TESTE.pdf"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --obra) OBRA_DIR="$2"; shift 2;;
    --capitulos) CAP_DIR_NAME="$2"; shift 2;;
    --title) TITLE="$2"; shift 2;;
    --author) AUTHOR="$2"; shift 2;;
    --advisor) ADVISOR="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Arg desconhecido: $1" >&2; exit 2;;
  esac
done

if [[ -z "${OBRA_DIR}" || -z "${CAP_DIR_NAME}" ]]; then
  echo "Uso: --obra <dir> --capitulos <nome_dir_capitulo> [--title ... --author ... --advisor ... --out ...]" >&2
  exit 2
fi

# ============= Paths/templates =============
BASE="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$BASE/bin"
TEMPL="$BASE/templates"

ABNT_HEADER="$TEMPL/abnt_header.tex"

CAP_PT_DIR="$OBRA_DIR/pt/01_capitulos/$CAP_DIR_NAME"
if [[ ! -d "$CAP_PT_DIR" ]]; then
  echo "❌ Pasta de capítulo não encontrada: $CAP_PT_DIR" >&2
  exit 1
fi

# ============= Seed/normalização de fontes =============
TMP_DIR="$(mktemp -d -t relatorio_XXXXXX)"

# Copiamos os .md relevantes em ordem, se existirem
order=(
  "$OBRA_DIR/pt/00_front-matter/Resumo.md"
  "$CAP_PT_DIR/00_intro.md"
  "$CAP_PT_DIR/01_ideias_principais.md"
  "$CAP_PT_DIR/02_conceitos_chave.md"
  "$CAP_PT_DIR/03_questoes_reflexao.md"
  "$CAP_PT_DIR/04_trechos_relevantes.md"
)

TMP_MD=()
for src in "${order[@]}"; do
  if [[ -f "$src" ]]; then
    dst="$TMP_DIR/$(basename "$src" | sed 's/Resumo.md/00_front_resumo.md/')"
    cp "$src" "$dst"
    TMP_MD+=("$dst")
  fi
done

# Normalizar para UTF-8 e limpar Unicode problemático (se script existir)
if [[ -x "$BIN/normalize_text.sh" ]]; then
  for f in "${TMP_MD[@]}"; do
    "$BIN/normalize_text.sh" "$f" >/dev/null || true
  done
fi
if [[ -x "$BIN/normalize_utf8.sh" ]]; then
  "$BIN/normalize_utf8.sh" "$TMP_DIR" >/dev/null || true
fi

# ============= Capa via envsubst (robusta) =============
ABNT_COVER_TMP="$(mktemp -t abnt_cover_XXXX.tex)"

# Variáveis de capa (com defaults seguros)
INSTIT="${INSTIT:-Universidade de São Paulo}"
CITY="${CITY:-São Paulo}"
DATE="${DATE:-\today}"

export TITLE AUTHOR ADVISOR INSTIT CITY DATE
envsubst '${TITLE} ${AUTHOR} ${ADVISOR} ${INSTIT} ${CITY} ${DATE}' \
  < "$TEMPL/abnt_cover.tex" > "$ABNT_COVER_TMP"

# ============= Pandoc =============
LOG="$TMP_DIR/pandoc.log"

echo "→ Arquivos incluídos:"
for f in "${TMP_MD[@]}"; do echo "   • $f"; done

echo "▶ Gerando PDF…"
if pandoc "${TMP_MD[@]}" \
  --from=markdown \
  --pdf-engine=xelatex \
  --toc --toc-depth=2 \
  --number-sections -V secnumdepth=1 \
  -V documentclass=article \
  --include-in-header="$ABNT_HEADER" \
  --include-before-body="$ABNT_COVER_TMP" \
  -o "$OUT" 2> "$LOG"; then
  echo "✅ PDF gerado em: $OUT"
else
  echo "❌ Erro na geração do PDF. Veja o log: $LOG"
  sed -n '1,200p' "$LOG" || true
  exit 1
fi
