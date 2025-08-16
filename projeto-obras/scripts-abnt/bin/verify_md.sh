#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "uso: $(basename "$0") CAMINHO_DO_CAPITULO"
  echo "ex.: projeto-obras/scripts-abnt/bin/verify_md.sh obras/MinhaObra/pt/01_capitulos/Capítulo_01"
}

CAP_DIR="${1:-}"
[ -n "$CAP_DIR" ] || { usage; exit 2; }
[ -d "$CAP_DIR" ] || { echo "ERRO: diretório não existe: $CAP_DIR" >&2; exit 2; }

fail=0

# 1) 00_intro obrigatório
if [ ! -f "$CAP_DIR/00_intro.md" ]; then
  echo "✗ Falta $CAP_DIR/00_intro.md"
  fail=1
fi

# 2) cada .md deve ser UTF-8
while IFS= read -r -d '' f; do
  if ! iconv -f UTF-8 -t UTF-8 "$f" >/dev/null 2>&1; then
    echo "✗ Não-UTF8: $f"
    fail=1
  fi
done < <(find "$CAP_DIR" -maxdepth 1 -type f -name '*.md' -print0)

# 3) seções proibidas
for pat in "Conex(ões|oes)" "Metadados adicionais" "Sugest(ões|oes) de linkagem" "Insights?"; do
  if grep -Eqi "^\#\#\s*${pat}" "$CAP_DIR"/*.md 2>/dev/null; then
    echo "✗ Seção proibida encontrada (${pat}) em $CAP_DIR"
    fail=1
  fi
done

# 4) links não achatados (wiki/markdown)
if grep -Eq '\[\[.*\]\]|\[[^]]+\]\([^)]+\)' "$CAP_DIR"/*.md 2>/dev/null; then
  echo "✗ Há links wiki/markdown não convertidos em $CAP_DIR"
  fail=1
fi

# 5) Unicode problemático (NBSP, hífens especiais, VS16) — compatível com macOS
if perl -ne '
  binmode STDIN, ":utf8";
  if (/\x{00A0}|\x{2011}|\x{2013}|\x{2014}|\x{FE0F}/) { print "hit\n"; exit 0 }
  END { exit 1 }
' "$CAP_DIR"/*.md 2>/dev/null; then
  echo "✗ Unicode problemático (NBSP/hífens/VS16) em $CAP_DIR"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "✓ OK: $CAP_DIR passa nas verificações."
else
  exit 1
fi
