#!/usr/bin/env bash
set -euo pipefail

ROOT="ICB-USP_Consciência/01_The_Character_of_Consciousness"
PT_GLOB="$ROOT/Capítulo_*"
EN_GLOB="$ROOT/en/01_chapters/Chapter_*"
REQ_PT=( "00_intro.md" "Ideias_Principais.md" "Conceitos_Chave.md" "Questoes_Reflexao.md" "Trechos_Relevantes.md" )
REQ_EN=( "00_intro.md" "Main_Ideas.md" "Key_Concepts.md" "Reflection_Questions.md" "Relevant_Passages.md" )

miss=0

echo "== Capítulos PT =="
shopt -s nullglob
pt_dirs=( $PT_GLOB )
if ((${#pt_dirs[@]}==0)); then echo "FALTA: diretórios PT ($PT_GLOB)"; miss=1; fi
for d in "${pt_dirs[@]:-}"; do
  echo "PT: $(basename "$d")"
  for f in "${REQ_PT[@]}"; do
    [[ -f "$d/$f" ]] || { echo "  FALTA: $f"; miss=1; }
  done
done

echo
echo "== Capítulos EN =="
en_dirs=( $EN_GLOB )
if ((${#en_dirs[@]}==0)); then echo "FALTA: diretórios EN ($EN_GLOB)"; miss=1; fi
for d in "${en_dirs[@]:-}"; do
  echo "EN: $(basename "$d")"
  for f in "${REQ_EN[@]}"; do
    [[ -f "$d/$f" ]] || { echo "  FALTA: $f"; miss=1; }
  done
done

echo
echo "== Consolidados esperados =="
PT_OUT="docs/obras/The_Character_of_Consciousness/01_The_Character_of_Consciousness_pt.md"
EN_OUT="docs/obras/The_Character_of_Consciousness/01_The_Character_of_Consciousness_en.md"
[[ -f "$PT_OUT" ]] || { echo "FALTA: $PT_OUT"; miss=1; }
[[ -f "$EN_OUT" ]] || { echo "FALTA: $EN_OUT"; miss=1; }

echo
echo "== Templates ABNT =="
tmpl_ok=0
for t in \
  scripts-abnt/templates/relatorio-abnt-usp.tex \
  scripts-abnt/templates/relatorio-abntex2.tex \
  scripts-abnt/templates/abnt-usp-template.tex
do
  if [[ -f "$t" ]]; then echo "OK: $t"; tmpl_ok=1; fi
done
((tmpl_ok==1)) || { echo "FALTA: ao menos um template .tex em scripts-abnt/templates"; miss=1; }

echo
echo "== Referências =="
[[ -f "$ROOT/Referencias_Zotero.md" ]] || echo "AVISO: falta $ROOT/Referencias_Zotero.md"

echo
echo "== Ferramentas =="
if command -v pandoc >/dev/null 2>&1; then pandoc -v | head -n1; else echo "FALTA: pandoc"; miss=1; fi
if command -v xelatex >/dev/null 2>&1; then xelatex --version | head -n1; \
elif command -v lualatex >/dev/null 2>&1; then lualatex --version | head -n1; \
else echo "FALTA: xelatex/lualatex (TeXLive + abnTeX2)"; miss=1; fi

echo
if ((miss==0)); then
  echo "AUDITORIA OK: pronto para montar PDFs PT/EN."
else
  echo "AUDITORIA FALHOU: corrija os itens FALTA acima."
  exit 1
fi
