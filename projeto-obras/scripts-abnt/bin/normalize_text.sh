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
