#!/usr/bin/env bash
set -euo pipefail

obra="The_Character_of_Consciousness"
PT="content/$obra/pt"
EN="content/$obra/en"
out_pt="docs/relatorios/Relatorio_PT.md"
out_en="docs/relatorios/Relatorio_EN.md"

# Remove YAML front matter do STDIN
strip_yaml() { perl -0777 -pe 's/^[ \t]*---\s*\n.*?\n[ \t]*(?:---|\.\.\.)\s*\n//msg'; }

: >"$out_pt"; : >"$out_en"

chap_files=( "00_intro.md" "Ideias_Principais.md" "Conceitos_Chave.md" "Questoes_Reflexao.md" "Trechos_Relevantes.md" )

# ----- PT -----
for cap in cap01 cap02 cap03 cap04 cap05 cap06; do
  CAP=$(printf '%s' "$cap" | tr '[:lower:]' '[:upper:]'); seen=0
  for f in "${chap_files[@]}"; do
    src="$PT/$cap/$f"; [[ -f "$src" ]] || continue
    if [[ $seen -eq 0 ]]; then printf "## %s\n\n" "$CAP" >>"$out_pt"; seen=1; fi
    printf "### %s\n\n" "${f%.md}" >>"$out_pt"
    strip_yaml <"$src" >>"$out_pt"; printf "\n" >>"$out_pt"
  done
  [[ $seen -eq 1 ]] && { printf "\\clearpage\n\n" >>"$out_pt"; }
done

# ----- EN -----
for cap in cap01 cap02 cap03 cap04 cap05 cap06; do
  CAP=$(printf '%s' "$cap" | tr '[:lower:]' '[:upper:]'); seen=0
  for f in "${chap_files[@]}"; do
    src_en="$EN/$cap/$f"; src_pt="$PT/$cap/$f"
    if [[ -f "$src_en" ]]; then
      if [[ $seen -eq 0 ]]; then printf "## %s\n\n" "$CAP" >>"$out_en"; seen=1; fi
      printf "### %s\n\n" "${f%.md}" >>"$out_en"
      strip_yaml <"$src_en" >>"$out_en"; printf "\n" >>"$out_en"
    elif [[ -f "$src_pt" ]]; then
      if [[ $seen -eq 0 ]]; then printf "## %s\n\n" "$CAP" >>"$out_en"; seen=1; fi
      printf "### %s\n\n" "${f%.md}" >>"$out_en"
      printf "> TODO: translate to English\n\n" >>"$out_en"
      strip_yaml <"$src_pt" >>"$out_en"; printf "\n" >>"$out_en"
    fi
  done
  [[ $seen -eq 1 ]] && { printf "\\clearpage\n\n" >>"$out_en"; }
done

# Compilar PDFs com o pipeline atual (Pandoc -> XeLaTeX)
python3 scripts-abnt/bin/build_report.py
