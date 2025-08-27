#!/usr/bin/env bash
set -euo pipefail

TEXTPL="${1:-scripts-abnt/templates/relatorio-abnt-usp.tex}"
OUTDIR="$(mktemp -d)"
cd "$OUTDIR"

# Probe LaTeX: imprime parâmetros no .log e força geração de elementos
cat > probe.tex <<'TEX'
\PassOptionsToClass{12pt,openright,oneside}{abntex2}
\documentclass{abntex2}
\usepackage{lipsum}
\usepackage{geometry}
\usepackage{fontspec}
\usepackage{tocloft}
\usepackage{etoolbox}
% === CAPA/PRÉ-TEXTUAIS (mínimos) ===
\titulo{Probe Title}
\autor{Autor Probe}
\instituicao{Universidade de São Paulo}
\local{São Paulo}
\data{2025}
\orientador{Prof. Orientador}
% === Impressões de diagnóstico no log ===
\makeatletter
\typeout{ABNTCHECK:paperwidth=\the\paperwidth}
\typeout{ABNTCHECK:paperheight=\the\paperheight}
\typeout{ABNTCHECK:textwidth=\the\textwidth}
\typeout{ABNTCHECK:textheight=\the\textheight}
\typeout{ABNTCHECK:oddsidemargin=\the\oddsidemargin}
\typeout{ABNTCHECK:topmargin=\the\topmargin}
\typeout{ABNTCHECK:baselineskip=\the\baselineskip}
\typeout{ABNTCHECK:mainfont=\fontname\font}
\makeatother
% === Corpo ===
\begin{document}
\selectlanguage{brazil}
\imprimircapa
\imprimirfolhaderosto*
\tableofcontents*
\listoffigures*
\listoftables*
\chapter{Introdução}
\lipsum[1-2]
\section{Seção}
\lipsum[3-4]
\chapter{Fundamentação}
\lipsum[5-6]
\bibliographystyle{abntex2-alf}
\begin{thebibliography}{99}
\bibitem{ex} SOBRENOME, A. Título. Local: Editora, 2020.
\end{thebibliography}
\end{document}
TEX

# compila usando o seu template via pandoc (mesmo engine/ambiente do projeto)
# Aqui chamamos latexmk direto para acelerar e capturar o .log.
latexmk -xelatex -interaction=nonstopmode -halt-on-error probe.tex >/dev/null 2>&1 || true

# Extrai métricas do .log
log="probe.log"
getv(){ grep -E "ABNTCHECK:$1=" "$log" | sed -E "s/.*$1=//"; }

paperw=$(getv paperwidth)
paperh=$(getv paperheight)
textw=$(getv textwidth)
texth=$(getv textheight)
oddsm=$(getv oddsidemargin)
topm=$(getv topmargin)
base=$(getv baselineskip)
font=$(getv mainfont)

# Regras esperadas (ajuste se sua unidade estiver em pt)
ok=1
echo "== Diagnóstico ABNT/USP (heurístico) =="
echo "-- Papel: $paperw x $paperh (esperado ~ 597.50787pt x 845.04684pt ≈ A4)"
echo "-- Área de texto: $textw x $texth"
echo "-- Margem esq (oddsidemargin): $oddsm  | Margem sup (topmargin): $topm"
echo "-- Espaçamento base (baselineskip): $base"
echo "-- Fonte atual: $font"

# Checagens simples (tolerâncias largas)
grep -q "597.5pt" <<<"$paperw" || { echo "FALTA: papel A4 (portrait)"; ok=0; }
grep -q "845.0pt" <<<"$paperh" || { echo "FALTA: papel A4 (portrait)"; ok=0; }

# Verifica presença de elementos pré-textuais no PDF via strings (capa, folha de rosto, ToC)
pdfok=1
if command -v strings >/dev/null 2>&1; then
  strings probe.pdf | grep -qi "Universidade de São Paulo" || { echo "FALTA: identificação USP na capa/folha de rosto"; pdfok=0; }
  strings probe.pdf | grep -qi "Sumário" || { echo "FALTA: Sumário gerado automaticamente"; pdfok=0; }
  strings probe.pdf | grep -qi "Lista de ilustrações|Lista de figuras" || echo "AVISO: Lista de figuras não detectada"
  strings probe.pdf | grep -qi "Lista de tabelas" || echo "AVISO: Lista de tabelas não detectada"
else
  echo "AVISO: 'strings' não disponível para inspecionar o PDF."
fi

# Resultado
if [[ $ok -eq 1 && $pdfok -eq 1 ]]; then
  echo "OK: Template aparenta aderência básica ABNT/USP (verifique detalhes finos de capa, margens e tipografia)."
  exit 0
else
  echo "AUDITORIA COM PENDÊNCIAS: ajuste template e recalcule."
  exit 1
fi
