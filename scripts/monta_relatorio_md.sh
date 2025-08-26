#!/usr/bin/env bash
set -euo pipefail

# === Diretórios ===
BASE="/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência"
OBRA_DIR="$BASE/ICB-USP_Consciência/01_The_Character_of_Consciousness"
OUT_DIR="$BASE/ICB-USP_Consciência/Relatorios"
OUT_MD="$OUT_DIR/Relatorio_The_Character_of_Consciousness_PT.md"

# Metadados
TITLE="Relatório de Leitura — THE CHARACTER OF CONSCIOUSNESS"
AUTHOR="Marcos Antonio de Menezes"
ADVISOR="Walter Chesnut"
INSTITUTION="ICB/USP"
LOCATION="São Paulo"
YEAR="2025"

mkdir -p "$OUT_DIR"

# Coleta e ordena arquivos (compatível com Bash 3.2)
FILES=()
for f in "$OBRA_DIR"/00_*.md "$OBRA_DIR"/cap*.md; do
  [ -e "$f" ] || continue
  FILES+=("$f")
done
if [ ${#FILES[@]} -eq 0 ]; then
  echo "❌ Nenhum .md encontrado em: $OBRA_DIR" >&2
  exit 1
fi
IFS=$'\n' FILES=($(printf '%s\n' "${FILES[@]}" | LC_ALL=C sort)); unset IFS

# Concatena num único .md
{
  echo "---"
  echo "title: \"$TITLE\""
  echo "author: \"$AUTHOR\""
  echo "advisor: \"$ADVISOR\""
  echo "institution: \"$INSTITUTION\""
  echo "location: \"$LOCATION\""
  echo "year: \"$YEAR\""
  echo "lang: pt-BR"
  echo "date: \"$YEAR\""
  echo "---"
  echo

  first=1
  for f in "${FILES[@]}"; do
    [ $first -eq 1 ] || printf '\n\\newpage\n\n'
    first=0
    cat "$f"
    echo
  done
} > "$OUT_MD"

echo "✅ Relatório consolidado em Markdown criado:"
echo "   $OUT_MD"
