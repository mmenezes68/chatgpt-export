#!/usr/bin/env bash
set -euo pipefail

for infile in "$@"; do
  [[ -f "$infile" ]] || { echo "ignorado: $infile"; continue; }
  tmp1="${infile}.tmp1"
  tmp2="${infile}.tmp2"
  tmp3="${infile}.tmp3"

  # 1) Normaliza cabeçalhos sujos
  sed -E '
    s/^##[[:space:]]*00[_ ]intro\.md/## Introdução/;
    s/^##[[:space:]]*Ideias[_ ]Principais\.md/## Ideias Principais/;
    s/^##[[:space:]]*Conceitos[_ ]Chave\.md/## Conceitos-Chave/;
    s/^##[[:space:]]*Questoes[_ ]Reflexao\.md/## Questões de Reflexão/;
    s/^##[[:space:]]*Trechos[_ ]Relevantes\.md/## Trechos Relevantes/;

    s/^##[[:space:]]*Main[_ ]Ideas\.md/## Main Ideas/;
    s/^##[[:space:]]*Key[_ ]Concepts\.md/## Key Concepts/;
    s/^##[[:space:]]*Reflection[_ ]Questions\.md/## Reflection Questions/;
    s/^##[[:space:]]*Relevant([ _])?Passages\.md/## Relevant Passages/;
    s/^##[[:space:]]*00([ _])?intro\.md/## Introduction/;
  ' "$infile" > "$tmp1"

  # 2) Remove blocos de capa/sumário duplicados
  /usr/bin/perl -CSDA -Mutf8 -0777 -pe '
    s/\n#+[ \t]*(Capa|Cover|Front Page|Folha de rosto|Folha de Rosto)\b.*?(?=\n#+|\z)//gis;
    s/\n#+[ \t]*(Índice|Sumário|Table of Contents|Contents)\b.*?(?=\n#+|\z)//gis;
  ' -i'' "$tmp1"

  # 3) Remove capítulos "duplicados" de Introdução
  awk '
    function is_intro(l){ return (l ~ /^##[ \t]+(Introdu[cç][aã]o|Introduction)$/) }
    BEGIN { in_dup=0; seen=0 }
    {
      if (in_dup) {
        if ($0 ~ /^##[ \t]+/) { in_dup=0; print; next } else { next }
      }
      if (is_intro($0)) {
        if (seen) { in_dup=1; next }
        seen=1; print; next
      }
      print
    }
  ' "$tmp1" > "$tmp2"

  # 4) Troca segura do símbolo ≠ por LaTeX
  /usr/bin/perl -CSDA -Mutf8 -pe 's/≠/\\(\\neq\\)/g' -i'' "$tmp2"

  # 5) Compacta linhas em branco consecutivas
  awk 'NR==1{print;prev=$0;next} { if(prev=="" && $0=="") next; print; prev=$0 }' "$tmp2" > "$tmp3"

  mv "$tmp3" "$infile"
  rm -f "$tmp1" "$tmp2"
  echo "Sanitizado: $infile"
done
