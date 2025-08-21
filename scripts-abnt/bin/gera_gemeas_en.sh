#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <diretorio_da_obra>"
  echo "Exemplos:"
  echo "  $0 ICB-USP_Consciência/01_The_Character_of_Consciousness"
  echo "  $0 projeto-obras/obras/The_Character_of_Consciousness"
  exit 1
fi

obra_dir="$1"

mkdir -p "$obra_dir/en/01_chapters"

pt_dirs=()
shopt -s nullglob
for d in "$obra_dir"/Capítulo_*; do [[ -d "$d" ]] && pt_dirs+=("$d"); done
for d in "$obra_dir"/pt/01_capitulos/Capítulo_*; do [[ -d "$d" ]] && pt_dirs+=("$d"); done
shopt -u nullglob

if [[ ${#pt_dirs[@]} -eq 0 ]]; then
  echo "Nenhum diretório 'Capítulo_*' encontrado em:"
  echo "  - $obra_dir/Capítulo_*"
  echo "  - $obra_dir/pt/01_capitulos/Capítulo_*"
  exit 0
fi

for pt_dir in "${pt_dirs[@]}"; do
  base_pt="$(basename "$pt_dir")"
  base_en="${base_pt/Capítulo_/Chapter_}"
  en_dir="$obra_dir/en/01_chapters/$base_en"
  mkdir -p "$en_dir"

  if [[ ! -f "$pt_dir/00_intro.md" ]]; then
    cat <<'MD' > "$pt_dir/00_intro.md"
# Introdução

Resumo do capítulo em português.
MD
  fi

  if [[ ! -f "$en_dir/00_intro.md" ]]; then
    cat <<'MD' > "$en_dir/00_intro.md"
# Introduction

Summary of the chapter in English.
MD
  fi

  while IFS= read -r mapping; do
    pt_file="${mapping%%:*}"
    en_file="${mapping#*:}"

    if [[ ! -f "$pt_dir/$pt_file" ]]; then
      titulo_pt="$(echo "${pt_file%.md}" | sed 's/_/ /g')"
      cat <<MD > "$pt_dir/$pt_file"
# ${titulo_pt}

(Preencha aqui o conteúdo em português)
MD
    fi

    if [[ ! -f "$en_dir/$en_file" ]]; then
      titulo_en="$(echo "${en_file%.md}" | sed 's/_/ /g')"
      cat <<MD > "$en_dir/$en_file"
# ${titulo_en}

(Fill in the English content here)
MD
    fi
  done <<'MAP'
Ideias_Principais.md:Main_Ideas.md
Conceitos_Chave.md:Key_Concepts.md
Questoes_Reflexao.md:Reflection_Questions.md
Trechos_Relevantes.md:Relevant_Passages.md
MAP
done

echo "OK: EN/chapters e arquivos gerados/garantidos em: $obra_dir/en/01_chapters"
