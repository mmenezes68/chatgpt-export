#!/usr/bin/env bash
# Copia .md PT do capítulo selecionado e cria esboços EN com marcador de tradução.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "uso: seed_en_from_pt.sh OBRA_DIR \"Nome_da_Pasta_do_Capitulo_PT\""
  exit 2
fi

OBRA="$1"
CAP_PT="$2"

SRC_DIR="$OBRA/$CAP_PT"
DEST_DIR="$OBRA/en/01_chapters/$(basename "$CAP_PT" | sed 's/^Capítulo_/Chapter_/')"

mkdir -p "$DEST_DIR"
for name in Conceitos_Chave Ideias_Principais Questoes_Reflexao Trechos_Relevantes; do
  src="$SRC_DIR/${name}.md"
  [[ -f "$src" ]] || continue
  base_en="$(echo "$name" | sed -e 's/Conceitos_Chave/Key_Concepts/' \
                                -e 's/Ideias_Principais/Main_Ideas/' \
                                -e 's/Questoes_Reflexao/Reflection_Questions/' \
                                -e 's/Trechos_Relevantes/Relevant_Passages/')"
  dst="$DEST_DIR/${base_en}.md"
  {
    echo "# TODO: Translate below to English"
    echo
    cat "$src"
  } > "$dst"
  echo "→ Seed EN: $dst"
done
