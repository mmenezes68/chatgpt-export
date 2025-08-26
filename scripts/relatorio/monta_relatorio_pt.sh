#!/usr/bin/env bash
set -euo pipefail

# === Caminhos ===
BASE="/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência"
BOOK_DIR="$BASE/ICB-USP_Consciência/01_The_Character_of_Consciousness"
OUT_DIR="$BASE/ICB-USP_Consciência/Relatorios"
OUT_MD="$OUT_DIR/Relatorio_The_Character_of_Consciousness_PT.md"

mkdir -p "$OUT_DIR"

# === YAML (título em CAIXA ALTA) ===
today="$(date +%Y-%m-%d)"
cat > "$OUT_MD" <<EOF
---
title: "RELATÓRIO DE LEITURA — THE CHARACTER OF CONSCIOUSNESS"
author: "Marcos Antonio de Menezes"
advisor: "Walter Chesnut"
institution: "ICB/USP"
location: "São Paulo"
year: "$(date +%Y)"
lang: pt-BR
date: "$today"
---
EOF
printf '\n' >> "$OUT_MD"

# === Seleção da introdução ===
INTRO=""
if [ -f "$BOOK_DIR/intro.md" ]; then
  INTRO="$BOOK_DIR/intro.md"
elif [ -f "$BOOK_DIR/01_The_Character_of_Consciousness_pt.md" ]; then
  INTRO="$BOOK_DIR/01_The_Character_of_Consciousness_pt.md"
else
  echo "⚠️  Introdução não encontrada em: $BOOK_DIR" >&2
fi

first=1
append_file() {
  local f="$1"
  [ -s "$f" ] || return 0
  if [ $first -eq 1 ]; then
    first=0
  else
    printf '\n\\newpage\n\n' >> "$OUT_MD"
  fi
  cat "$f" >> "$OUT_MD"
  printf '\n' >> "$OUT_MD"
}

# 1) Introdução
[ -n "$INTRO" ] && append_file "$INTRO"

# 2) Capítulos (Capítulo_*), cada .md em ordem
#   – usa find + sort para ordem estável mesmo com acentos
#   – concatena todos os .md de cada capítulo
while IFS= read -r -d '' chap_dir; do
  # todos os .md do capítulo, ordenados
  while IFS= read -r -d '' md; do
    append_file "$md"
  done < <(find "$chap_dir" -maxdepth 1 -type f -name '*.md' -print0 | sort -z)
done < <(find "$BOOK_DIR" -maxdepth 1 -type d -name 'Capítulo_*' -print0 | sort -z)

echo "✅ Relatório consolidado:"
echo "   $OUT_MD"
echo
echo "Para gerar PDF ABNT com seu template:"
echo 'pandoc "'"$OUT_MD"'" --from markdown --pdf-engine=xelatex \'
echo '  --template='"'"'scripts-abnt/templates/relatorio-abnt-usp.tex'"'"' \'
echo '  -o "'"$OUT_DIR"'/Relatorio_The_Character_of_Consciousness_PT.pdf"'
