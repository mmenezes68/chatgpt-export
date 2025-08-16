#!/usr/bin/env bash
set -euo pipefail

# --- args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --obra) OBRA="$2"; shift 2;;
    --capitulos) CAPS="$2"; shift 2;;
    --title) TITLE="$2"; shift 2;;
    --author) AUTHOR="$2"; shift 2;;
    --advisor) ADVISOR="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Arg desconhecido: $1"; exit 1;;
  esac
done

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TMP_DIR="$(mktemp -d /tmp/relatorio_XXXX)"
ABNT_COVER_TMP="$TMP_DIR/cover.tex"
ABNT_COVER="$BASE_DIR/templates/abnt_cover.tex"
ABNT_HEADER="$BASE_DIR/templates/abnt_header.tex"

# Substitui variáveis da capa
sed \
  -e "s|__TITULO__|$TITLE|g" \
  -e "s|__AUTHOR__|$AUTHOR|g" \
  -e "s|__ADVISOR__|$ADVISOR|g" \
  "$ABNT_COVER" > "$ABNT_COVER_TMP"

TMP_MD=()

for CAP in $CAPS; do
  CAP_DIR="$OBRA/$CAP"
  if [ ! -d "$CAP_DIR" ]; then
    echo "⚠️  Capítulo não encontrado: $CAP_DIR"
    continue
  fi

  # adiciona front-matter se existir
  FRONT_PT="$OBRA/pt/00_front-matter/Resumo.md"
  FRONT_EN="$OBRA/en/00_front-matter/Abstract.md"
  if [ -f "$FRONT_PT" ]; then
    TMP_F="$(mktemp "$TMP_DIR/front_pt_XXXX.md")"
    cp "$FRONT_PT" "$TMP_F"
    "$BASE_DIR/bin/normalize_text.sh" "$TMP_F"
    TMP_MD+=("$TMP_F")
  elif [ -f "$FRONT_EN" ]; then
    TMP_F="$(mktemp "$TMP_DIR/front_en_XXXX.md")"
    cp "$FRONT_EN" "$TMP_F"
    "$BASE_DIR/bin/normalize_text.sh" "$TMP_F"
    TMP_MD+=("$TMP_F")
  fi

  # adiciona intro se existir
  for INTRO in "$CAP_DIR/00_intro.md" "$CAP_DIR/00-Intro.md" "$CAP_DIR/Intro.md"; do
    if [ -f "$INTRO" ]; then
      TMP_I="$(mktemp "$TMP_DIR/intro_XXXX.md")"
      cp "$INTRO" "$TMP_I"
      "$BASE_DIR/bin/normalize_text.sh" "$TMP_I"
      TMP_MD+=("$TMP_I")
      break
    fi
  done

  # inclui os quatro arquivos principais
  for PART in Conceitos_Chave Ideias_Principais Questoes_Reflexao Trechos_Relevantes; do
    FILE="$CAP_DIR/${PART}.md"
    if [ -f "$FILE" ]; then
      TMP_F="$(mktemp "$TMP_DIR/${PART}_XXXX.md")"
      cp "$FILE" "$TMP_F"
      "$BASE_DIR/bin/normalize_text.sh" "$TMP_F"
      TMP_MD+=("$TMP_F")
    fi
  done
done

echo "→ Arquivos incluídos:"
for f in "${TMP_MD[@]}"; do echo "   • $f"; done

LOG="$TMP_DIR/pandoc.log"

if pandoc "${TMP_MD[@]}" \
  --from markdown \
  --pdf-engine=xelatex \
  --toc \
  --toc-depth=2 \
  --number-sections -V secnumdepth=1 \
  -V documentclass=article \
  --include-in-header="$ABNT_HEADER" \
  --include-before-body="$ABNT_COVER_TMP" \
  -o "$OUT" 2> "$LOG"; then
  echo "✅ PDF gerado em: $OUT"
else
  echo "❌ Erro na geração do PDF. Veja o log: $LOG"; exit 1
fi
