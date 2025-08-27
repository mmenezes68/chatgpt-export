#!/usr/bin/env bash
set -euo pipefail
for infile in "$@"; do
  [[ -f "$infile" ]] || { echo "ignorado: $infile"; continue; }
  tmp="${infile}.tmp"
  # Normaliza cabeçalhos “sujos” do consolidado PT/EN
  sed -E '
    s/^##[[:space:]]*00[_ ]intro\.md/## Introdução/;
    s/^##[[:space:]]*Ideias[_ ]Principais\.md/## Ideias Principais/;
    s/^##[[:space:]]*Conceitos[_ ]Chave\.md/## Conceitos-Chave/;
    s/^##[[:space:]]*Questoes[_ ]Reflexao\.md/## Questões de Reflexão/;
    s/^##[[:space:]]*Trechos[_ ]Relevantes\.md/## Trechos Relevantes/;

    s/^##[[:space:]]*Main[_ ]Ideas\.md/## Main Ideas/;
    s/^##[[:space:]]*Key[_ ]Concepts\.md/## Key Concepts/;
    s/^##[[:space:]]*Reflection[_ ]Questions\.md/## Reflection Questions/;
    s/^##[[:space:]]*Relevant[_ ]Passages\.md/## Relevant Passages/;
    s/^##[[:space:]]*00[_ ]intro\.md/## Introduction/;
  ' "$infile" > "$tmp"
  mv "$tmp" "$infile"
  echo "Sanitizado: $infile"
done
