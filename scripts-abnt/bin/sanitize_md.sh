#!/usr/bin/env bash
set -euo pipefail

# Uso: bash scripts-abnt/bin/sanitize_md.sh ARQUIVO1.md [ARQUIVO2.md …]
# Efeitos:
#  - Normaliza cabeçalhos "sujos" do consolidado (PT/EN)
#  - Remove blocos manuais de Capa/Folha de rosto/Sumário (PT/EN)
#  - Deduplica "Introdução/Introduction" (mantém só a 1ª, descarta as próximas até outro H2)
#  - Converte símbolo ≠ para LaTeX \( \neq \)
#  - Compacta linhas em branco consecutivas

for infile in "$@"; do
  [[ -f "$infile" ]] || { echo "ignorado: $infile"; continue; }

  tmp1="$(mktemp)"; tmp2="$(mktemp)"; tmp3="$(mktemp)"

  # 1) Normalização de cabeçalhos (placeholders comuns do consolidado)
  sed -E '
    s/^##[[:space:]]*00([ _])?intro\.md[[:space:]]*$/## Introdução/;
    s/^##[[:space:]]*Ideias([ _])?Principais\.md[[:space:]]*$/## Ideias Principais/;
    s/^##[[:space:]]*Conceitos([ _])?Chave\.md[[:space:]]*$/## Conceitos-Chave/;
    s/^##[[:space:]]*Questoes([ _])?Reflexao\.md[[:space:]]*$/## Questões de Reflexão/;
    s/^##[[:space:]]*Trechos([ _])?Relevantes\.md[[:space:]]*$/## Trechos Relevantes/;

    s/^##[[:space:]]*Main([ _])?Ideas\.md[[:space:]]*$/## Main Ideas/;
    s/^##[[:space:]]*Key([ _])?Concepts\.md[[:space:]]*$/## Key Concepts/;
    s/^##[[:space:]]*Reflection([ _])?Questions\.md[[:space:]]*$/## Reflection Questions/;
    s/^##[[:space:]]*Relevant([ _])?Passages\.md[[:space:]]*$/## Relevant Passages/;
    s/^##[[:space:]]*00([ _])?intro\.md[[:space:]]*$/## Introduction/;
  ' "$infile" > "$tmp1"

  # 2) Remoção de blocos manuais de capa/folha de rosto/sumário (PT/EN)
  /usr/bin/perl -CSDA -Mutf8 -0777 -pe '
    s/\n#+[ \t]*(Capa|Cover|Front Page|Folha de rosto|Folha de Rosto)\b.*?(?=\n#+|\z)//gis;
    s/\n#+[ \t]*(Índice|Sumário|Table of Contents|Contents)\b.*?(?=\n#+|\z)//gis;
  ' -i'' "$tmp1"

  # 3) Deduplicar Introdução/Introduction (mantém a 1ª)
  awk '
    function ltrim(s){ sub(/^[ \t\r\n]+/,"",s); return s }
    function is_h2(l) {
      return (l ~ /^##[ \t]+/)
    }
    function is_intro(l,   low) {
      low = tolower(l)
      # começa com "## " e em seguida algo do conjunto {introdução, introducao, introduction, intro}
      return (low ~ /^##[ \t]+(introdu..o|introducao|introduction|intro)\b/)
    }
    BEGIN { in_dup=0; seen=0 }
    {
      if (in_dup) {
        if (is_h2($0)) { in_dup=0; print; next } else { next }
      }
      if (is_intro($0)) {
        if (seen) { in_dup=1; next }
        seen=1; print; next
      }
      print
    }
  ' "$tmp1" > "$tmp2"

  # 4) Troca segura do símbolo ≠ por LaTeX \( \neq \)
  /usr/bin/perl -CSDA -Mutf8 -pe 's/≠/\\(\\neq\\)/g' -i'' "$tmp2"

  # 5) Compacta linhas em branco consecutivas
  awk 'NR==1{print; prev=$0; next} { if(prev=="" && $0=="") next; print; prev=$0 }' "$tmp2" > "$tmp3"

  mv "$tmp3" "$infile"
  rm -f "$tmp1" "$tmp2"
  echo "Sanitizado: $infile"
done
