#!/usr/bin/env bash
set -euo pipefail

# ===== Config básica =====
BASE="$(cd "$(dirname "$0")/.." && pwd)"
ABNT_HEADER="$BASE/templates/abnt_header.tex"
ABNT_COVER_TEMPLATE="$BASE/templates/abnt_cover.tex" # modelo com $TITLE etc.

# ===== Args =====
OBRA=""
CAPITULOS=""
TITLE=""
AUTHOR="${AUTHOR:-Marcos Antonio de Menezes}"
ADVISOR="${ADVISOR:-Prof. Walter Chesnut}"
INSTIT="${INSTIT:-Universidade de São Paulo — Instituto de Ciências Biomédicas (ICB-USP)}"
CITY="${CITY:-São Paulo}"
DATE="${DATE:-$(date +%d/%m/%Y)}"
OUT="$HOME/Relatorio.pdf"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --obra)       OBRA="$2"; shift 2;;
    --capitulos)  CAPITULOS="$2"; shift 2;;
    --title)      TITLE="$2"; shift 2;;
    --author)     AUTHOR="$2"; shift 2;;
    --advisor)    ADVISOR="$2"; shift 2;;
    --instit)     INSTIT="$2"; shift 2;;
    --city)       CITY="$2"; shift 2;;
    --date)       DATE="$2"; shift 2;;
    --out)        OUT="$2"; shift 2;;
    *) echo "Arg desconhecido: $1"; exit 2;;
  esac
done

if [[ -z "$OBRA" || -z "$CAPITULOS" || -z "$TITLE" ]]; then
  echo "uso: relatorio_full.sh --obra CAMINHO --capitulos \"Nome_da_Pasta\" --title \"Título\" [--out ARQ]"
  exit 2
fi

# ===== Funções =====
# Escape seguro para LaTeX (campos de capa)
latex_escape() {
  # substitui chars perigosos para LaTeX
  sed -e 's/\\/\\textbackslash{}/g' \
      -e 's/&/\\&/g' \
      -e 's/%/\\%/g' \
      -e 's/\$/\\$/g' \
      -e 's/#/\\#/g' \
      -e 's/_/\\_/g' \
      -e 's/{/\\{/g' \
      -e 's/}/\\}/g' \
      -e 's/\^/\\textasciicircum{}/g' \
      -e 's/~/\\textasciitilde{}/g'
}

normalize_vars() {
  # hífens/esp. não separáveis
  TITLE="$(printf '%s' "$TITLE"  | tr '\u2011\u2013\u2014\u00A0' '- - - ')"
  AUTHOR="$(printf '%s' "$AUTHOR" | tr '\u2011\u2013\u2014\u00A0' '- - - ')"
  ADVISOR="$(printf '%s' "$ADVISOR"| tr '\u2011\u2013\u2014\u00A0' '- - - ')"
  INSTIT="$(printf '%s' "$INSTIT" | tr '\u2011\u2013\u2014\u00A0' '- - - ')"
  CITY="$(printf '%s' "$CITY"     | tr '\u2011\u2013\u2014\u00A0' '- - - ')"

  # escape LaTeX
  TITLE="$(printf '%s' "$TITLE"   | latex_escape)"
  AUTHOR="$(printf '%s' "$AUTHOR" | latex_escape)"
  ADVISOR="$(printf '%s' "$ADVISOR"| latex_escape)"
  INSTIT="$(printf '%s' "$INSTIT" | latex_escape)"
  CITY="$(printf '%s' "$CITY"     | latex_escape)"
  DATE="$(printf '%s' "$DATE"     | latex_escape)"
}

# ===== Coleta de fontes =====
if [[ ! -d "$OBRA/$CAPITULOS" ]]; then
  echo "❌ Pasta de capítulos não encontrada: $OBRA/$CAPITULOS"; exit 1
fi

TMP_DIR="$(mktemp -d "/tmp/relatorio_XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

TMP_MD=()

# coleta os 4 arquivos padrão (ou o que existir) na ordem desejada
for name in Conceitos_Chave Ideias_Principais Questoes_Reflexao Trechos_Relevantes; do
  src="$OBRA/$CAPITULOS/${name}.md"
  if [[ -f "$src" ]]; then
    dst="$TMP_DIR/${name}.md"
    cp "$src" "$dst"
    # reencode + normalize
    "$BASE/bin/normalize_text.sh" "$dst"
    TMP_MD+=("$dst")
  fi
done

if [[ "${#TMP_MD[@]}" -eq 0 ]]; then
  echo "❌ Nenhum .md encontrado em $OBRA/$CAPITULOS"; exit 1
fi

echo "→ Arquivos incluídos:"; for f in "${TMP_MD[@]}"; do echo "   • $f"; done

# ===== Gera capa temporária com variáveis EXPANDIDAS =====
normalize_vars

ABNT_COVER_TMP="$TMP_DIR/abnt_cover_expanded.tex"
# Usa o template padrão se existir; caso contrário, gera um miolo simples
if [[ -f "$ABNT_COVER_TEMPLATE" ]]; then
  # Substitui placeholders via envsubst-like (uso do shell)
  cat > "$ABNT_COVER_TMP" <<TEX
% capa (sem número)
\thispagestyle{empty}
\begin{center}
  {\Large \textbf{$TITLE}}\par
  \vspace{1.2cm}
  {$AUTHOR}\par
  \vspace{0.4cm}
  {Orientador: $ADVISOR}\par
  \vspace{0.4cm}
  {$INSTIT}\par
  \vfill
  {$CITY}\par
  {$DATE}\par
\end{center}
\clearpage
TEX
else
  cat > "$ABNT_COVER_TMP" <<TEX
\thispagestyle{empty}
\begin{center}
  {\Large \textbf{$TITLE}}\par
  \vspace{1.2cm}
  {$AUTHOR}\par
  \vspace{0.4cm}
  {$INSTIT}\par
  \vfill
  {$CITY}\par
  {$DATE}\par
\end{center}
\clearpage
TEX
fi

# ===== Locale para PT (ajusta xelatex/babel)
export LANG="${LANG:-pt_BR.UTF-8}"
export LC_ALL="${LC_ALL:-pt_BR.UTF-8}"

# ===== Pandoc =====
LOG="$TMP_DIR/pandoc.log"
echo "▶ Gerando PDF…"
if pandoc "${TMP_MD[@]}" \
  --from markdown \
  --pdf-engine=xelatex \
  --toc --toc-depth=2 \
  --number-sections -V secnumdepth=1 \
  -V documentclass=article \
  --include-in-header="$ABNT_HEADER" \
  --include-before-body="$ABNT_COVER_TMP" \
  -o "$OUT" 2> "$LOG"; then
  echo "✅ PDF gerado em: $OUT"
else
  echo "❌ Erro na geração do PDF. Veja o log: $LOG"
  sed -n '1,120p' "$LOG" || true
  exit 1
fi
