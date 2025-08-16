#!/usr/bin/env bash
# Normaliza .md: EOL, front-matter, metadados redundantes, links, divisórias,
# poda seções não essenciais, limpeza unicode, etc.
set -euo pipefail

FILE="$1"
TMP="$(mktemp)"

# 1) Garante UTF-8 antes de tudo
"$(dirname "$0")/reencode_utf8.sh" "$FILE"

perl -CS -Mutf8 -0777 -pe '
  # --- EOL e BOM
  s/\r\n?/\n/g;
  s/\A\x{FEFF}//;

  # --- front-matter YAML do início
  s/\A---\n.*?\n---\n?//s;

  # --- remove blocos "metadados" (>=3 pares chave: valor num mesmo parágrafo)
  $_ = join("\n\n",
    grep {
      my $p = $_;
      my $hits = () = ($p =~ /(^|[ \t\|])\p{L}[\p{L}\p{M}\s\-]*:\s+/mg);
      $hits < 3
    } split(/\n{2,}/)
  );

  # --- links: [[alvo|texto]] -> texto ; [[alvo]] -> alvo ; [texto](url) -> texto
  s/\[\[([^|\]]+)\|([^]]+)\]\]/$2/g;
  s/\[\[([^]]+)\]\]/$1/g;
  s/\[([^\]]+)\]\((?:[^)]+)\)/$1/g;

  # --- remove URLs puras isoladas
  s/^(?:https?:\/\/|file:\/\/\/)\S+\s*$//mg;

  # --- linhas horizontais puras
  s/^\s*(?:-{3,}|_{3,}|\*{3,})\s*$//mg;

  # --- poda: seções que não fazem parte do relatório
  for my $pat (qw(
    Metadados\ adicionais.*
    Sugest(ões|oes)\ de\ linkagem.*
    Insights?.*
    Conex(ões|oes).*
  )) {
    s/^\#\#\s*$pat\s*\n(?:.*?\n)(?=^\#\#\s|\z)//gms;
  }

  # --- normalização unicode problemática
  tr/\x{00A0}/ /;                    # NBSP -> espaço
  s/[\x{2011}\x{2013}\x{2014}]/-/g;  # non-breaking/en/em dash -> -
  s/\x{FE0F}//g;                     # VS16
  s/\p{Extended_Pictographic}//g;    # emojis

  # --- remove controles C0/C1/DEL (preserva \n e \t)
  s/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]//g;
  s/[\x80-\x9F]//g;

  # --- espaços à direita
  s/[ \t]+$//mg;

  # --- cabeçalhos duplicados ocasionais
  s/^\#\#\#\#/\#\#\#/mg;
' "$FILE" > "$TMP"

mv "$TMP" "$FILE"
echo "→ Normalizado: $FILE"
