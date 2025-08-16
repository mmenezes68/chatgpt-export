#!/usr/bin/env bash
set -euo pipefail

# 1) Pastas
mkdir -p projeto-obras/scripts-abnt/bin projeto-obras/scripts-abnt/templates

# 2) normalize_text.sh
cat > projeto-obras/scripts-abnt/bin/normalize_text.sh <<'BASH'
#!/usr/bin/env bash
set -euo pipefail
if [ "$#" -lt 1 ]; then echo "uso: $0 arquivos.md..."; exit 2; fi
perl -CS -Mutf8 -0777 -i -pe '
  s/\r\n?/\n/g; s/\A\x{FEFF}//;
  s/\A---\n.*?\n---\n?//s;
  $_ = join("\n\n",
    grep {
      my $p = $_; my $hits = () = ($p =~ /(^|[ \t\|])\p{L}[\p{L}\p{M}\s\-]*:\s+/mg);
      $hits < 3
    } split(/\n{2,}/)
  );
  s/\[\[([^|\]]+)\|([^]]+)\]\]/$2/g;
  s/\[\[([^]]+)\]\]/$1/g;
  s/\[([^\]]+)\]\((?:[^)]+)\)/$1/g;
  s/^(?:https?:\/\/|file:\/\/\/)\S+\s*$//mg;
  s/^\s*(?:-{3,}|_{3,}|\*{3,})\s*$//mg;
  for my $pat (qw(
    Metadados\ adicionais.*
    Sugest(ões|oes)\ de\ linkagem.*
    Conex(ões|oes).*
    Insights?.*
  )) { s/^\#\#\s*$pat\s*\n(?:.*?\n)(?=^\#\#\s|\z)//gms; }
  tr/\x{00A0}/ /;
  s/[\x{2011}\x{2013}\x{2014}]/-/g;
  s/\x{FE0F}//g;
  s/\p{Extended_Pictographic}//g;
  s/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]//g;
  s/[\x80-\x9F]//g;
' "$@"
BASH
chmod +x projeto-obras/scripts-abnt/bin/normalize_text.sh

# 3) normalize_vars.sh
cat > projeto-obras/scripts-abnt/bin/normalize_vars.sh <<'BASH'
#!/usr/bin/env bash
normalize_vars() {
  local vars=(TITLE AUTHOR ADVISOR INSTIT CITY DATE)
  local v val
  for v in "${vars[@]}"; do
    val="$(eval "printf '%s' \"\${$v:-}\"")"
    val="${val//$'\u2011'/-}"
    val="${val//$'\u2013'/-}"
    val="${val//$'\u2014'/-}"
    val="${val//$'\u00A0'/ }"
    eval "$v=\"\$val\""
  done
}
BASH
chmod +x projeto-obras/scripts-abnt/bin/normalize_vars.sh

# 4) Templates LaTeX
cat > projeto-obras/scripts-abnt/templates/abnt_header.tex <<'TEX'
\usepackage[brazil]{babel}
\usepackage{fontspec}
\setmainfont{Times New Roman}
\usepackage[a4paper,top=3cm,bottom=2cm,left=3cm,right=2cm]{geometry}
\usepackage{setspace}\onehalfspacing
\usepackage{indentfirst}
\setlength{\parindent}{1.25cm}
\setlength{\parskip}{0pt}
\providecommand{\tightlist}{\setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
\renewcommand{\labelitemi}{\textbullet}
\addto\captionsbrazil{\renewcommand{\contentsname}{Sumário}}
\usepackage[hidelinks]{hyperref}
\usepackage{fancyhdr}
\pagestyle{fancy}\fancyhf{}\fancyfoot[C]{\thepage}
TEX

cat > projeto-obras/scripts-abnt/templates/abnt_cover.tex <<'TEX'
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

# 5) relatorio_full.sh
cat > projeto-obras/scripts-abnt/bin/relatorio_full.sh <<'BASH'
#!/usr/bin/env bash
set -euo pipefail
usage() {
  cat <<EOF
uso: $0 --obra CAMINHO_DA_OBRA --capitulos "PastaCap1[,PastaCap2...]" \\
         --title "Título" --author "Autor" --advisor "Orientador" --out /caminho/saida.pdf
opções:
  --city "Cidade"         (padrão: São Paulo)
  --instit "Instituição"  (padrão: USP — ICB)
  --date "DD/MM/AAAA"     (padrão: hoje)
EOF
}
OBRA=""; CAPITULOS=""; TITLE=""; AUTHOR=""; ADVISOR=""; OUT=""
CITY="São Paulo"; INSTIT="Universidade de São Paulo — Instituto de Ciências Biomédicas (ICB-USP)"
DATE="$(date +%d/%m/%Y)"
while [ $# -gt 0 ]; do
  case "$1" in
    --obra) OBRA="$2"; shift 2;;
    --capitulos) CAPITULOS="$2"; shift 2;;
    --title) TITLE="$2"; shift 2;;
    --author) AUTHOR="$2"; shift 2;;
    --advisor) ADVISOR="$2"; shift 2;;
    --city) CITY="$2"; shift 2;;
    --instit) INSTIT="$2"; shift 2;;
    --date) DATE="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "opção desconhecida: $1"; usage; exit 2;;
  esac
done
[ -n "$OBRA" ] && [ -n "$CAPITULOS" ] && [ -n "$TITLE" ] && [ -n "$AUTHOR" ] && [ -n "$ADVISOR" ] && [ -n "$OUT" ] || { usage; exit 2; }
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPL_DIR="$SCRIPT_DIR/../templates"
ABNT_HEADER="$TEMPL_DIR/abnt_header.tex"
ABNT_COVER="$TEMPL_DIR/abnt_cover.tex"
. "$SCRIPT_DIR/normalize_vars.sh"; normalize_vars
# coleta .md
INCLUDES=()
IFS=',' read -r CAPLIST <<< "$CAPITULOS"
for C in $CAPLIST; do
  C_DIR="$OBRA/$C"
  if [ ! -d "$C_DIR" ]; then echo "⚠️  Capítulo inexistente: $C_DIR"; continue; fi
  while IFS= read -r -d '' f; do INCLUDES+=("$f"); done < <(find "$C_DIR" -type f -name '*.md' -maxdepth 1 -print0 | sort -z)
done
[ "${#INCLUDES[@]}" -gt 0 ] || { echo "❌ Nenhum .md encontrado."; exit 1; }
# temporários
TMPDIR="$(mktemp -d /tmp/relatorio_XXXXXX)"; trap 'rm -rf "$TMPDIR"' EXIT
TMP_MD=()
for f in "${INCLUDES[@]}"; do b="$(basename "$f")"; cp -f "$f" "$TMPDIR/$b"; TMP_MD+=("$TMPDIR/$b"); done
"$SCRIPT_DIR/normalize_text.sh" "${TMP_MD[@]}"
# capa com variáveis
ABNT_COVER_TMP="$TMPDIR/cover.tex"
sed -e "s|\$TITLE|$TITLE|g" \
    -e "s|\$AUTHOR|$AUTHOR|g" \
    -e "s|\$ADVISOR|$ADVISOR|g" \
    -e "s|\$INSTIT|$INSTIT|g" \
    -e "s|\$CITY|$CITY|g" \
    -e "s|\$DATE|$DATE|g" "$ABNT_COVER" > "$ABNT_COVER_TMP"
# pandoc
LOG="${OUT%.pdf}.log"
echo "→ Arquivos incluídos:"; for f in "${TMP_MD[@]}"; do echo "   • $f"; done
echo "▶ Gerando PDF…"
if pandoc "${TMP_MD[@]}" \
  --from=markdown \
  --pdf-engine=xelatex \
  --toc --toc-depth=1 \
  --number-sections -V secnumdepth=1 \
  -V documentclass=article \
  --include-in-header="$ABNT_HEADER" \
  --include-before-body="$ABNT_COVER_TMP" \
  -o "$OUT" 2> "$LOG"; then
  echo "✅ PDF gerado em: $OUT"
else
  echo "❌ Erro na geração do PDF. Veja o log: $LOG"; exit 1
fi
BASH
chmod +x projeto-obras/scripts-abnt/bin/relatorio_full.sh

# 6) Git commit/push
git add -A
git commit -m "Kit inicial ABNT: normalização, templates e relatorio_full.sh" || true
git push || true

echo "OK: kit criado em projeto-obras/scripts-abnt/"
