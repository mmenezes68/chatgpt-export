#!/usr/bin/env bash
set -euo pipefail
lang="${1:-}"; [[ "$lang" =~ ^(pt|en)$ ]] || { echo "uso: $0 {pt|en} [RAIZ_DA_OBRA]"; exit 1; }
ROOT="${2:-01_The_Character_of_Consciousness}"

if [[ "$lang" == "en" ]]; then
  CHROOT="$ROOT/en/01_chapters"
  OUT="$ROOT/01_The_Character_of_Consciousness_en.md"
  sections=( "00_intro.md:Introduction"
             "Main_Ideas.md:Main Ideas"
             "Key_Concepts.md:Key Concepts"
             "Reflection_Questions.md:Reflection Questions"
             "Relevant_Passages.md:Relevant Passages" )
  mapfile -t chapters < <(ls -1 "$CHROOT"/Chapter_* 2>/dev/null | sort -V)
else
  CHROOT="$ROOT"
  OUT="$ROOT/01_The_Character_of_Consciousness_pt.md"
  sections=( "00_intro.md:Introdução"
             "Ideias_Principais.md:Ideias Principais"
             "Conceitos_Chave.md:Conceitos-Chave"
             "Questoes_Reflexao.md:Questões de Reflexão"
             "Trechos_Relevantes.md:Trechos Relevantes" )
  mapfile -t chapters < <(ls -1 "$CHROOT"/Capítulo_* 2>/dev/null | sort -V)
fi

(( ${#chapters[@]} )) || { echo "Sem capítulos $lang em: $CHROOT"; exit 1; }

{
  for d in "${chapters[@]}"; do
    name=$(basename "$d" | sed 's/_/ /g')
    echo
    echo "# $name"
    for pair in "${sections[@]}"; do
      file="${pair%%:*}"; title="${pair#*:}"
      [[ -f "$d/$file" ]] || continue
      echo
      echo "## $title"
      echo
      cat "$d/$file"
      echo
    done
    echo '\clearpage'
  done
} > "$OUT"
echo "OK: $OUT"
