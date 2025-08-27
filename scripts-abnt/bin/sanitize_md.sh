#!/usr/bin/env bash
set -euo pipefail

# Uso: bash scripts-abnt/bin/sanitize_md.sh <arquivo.md> [outro.md ...]
# Objetivo: normalizar títulos PT/EN e remover seções espúrias (Capa/Cover, TOC solto etc.)

for infile in "$@"; do
  [[ -f "$infile" ]] || { echo "ignorado: $infile"; continue; }
  tmp="${infile}.tmp"

  # 1) Normaliza cabeçalhos “sujos” gerados no consolidado (PT/EN)
  #    (mapas tolerantes a espaço/sublinha)
  sed -E '
    s/^##[[:space:]]*00([ _])?intro\.md/## Introdução/;
    s/^##[[:space:]]*Ideias([ _])?Principais\.md/## Ideias Principais/;
    s/^##[[:space:]]*Conceitos([ _])?Chave\.md/## Conceitos-Chave/;
    s/^##[[:space:]]*Questoes([ _])?Reflexao\.md/## Questões de Reflexão/;
    s/^##[[:space:]]*Trechos([ _])?Relevantes\.md/## Trechos Relevantes/;

    s/^##[[:space:]]*Main([ _])?Ideas\.md/## Main Ideas/;
    s/^##[[:space:]]*Key([ _])?Concepts\.md/## Key Concepts/;
    s/^##[[:space:]]*Reflection([ _])?Questions\.md/## Reflection Questions/;
    s/^##[[:space:]]*Relevant([ _])?Passages\.md/## Relevant Passages/;
    s/^##[[:space:]]*00([ _])?intro\.md/## Introduction/;
  ' "$infile" > "$tmp"

  # 2) Remove seções espúrias que às vezes aparecem no corpo
  #    (toc/capa fora do template)
  /usr/bin/perl -CSDA -Mutf8 -0777 -pe '
    s/\n#+[ \t]*(Capa|Cover)\s*\n(?:.*?\n){0,10}(?=\n#+|\Z)//g;              # bloco "Capa/Cover" solto
    s/\n#+[ \t]*(Índice|Sumário|Table of Contents)\s*\n(?:.*?\n){0,50}(?=\n#+|\Z)//g; # TOC manual
  ' -i'' "$tmp"

  # 3) Limpa linhas em branco em excesso
  awk 'NR==1{print;next} { if(prev=="" && $0=="") next; print; prev=$0 }' prev="" "$tmp" > "${tmp}.2"

  mv "${tmp}.2" "$infile"
  rm -f "$tmp"
  echo "Sanitizado: $infile"
done
