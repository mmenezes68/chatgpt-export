#!/usr/bin/env bash
# Normaliza texto Markdown (acentos, espaços, seções irrelevantes)
set -euo pipefail

FILE="$1"
TMP="$(mktemp)"

perl -0777 -pe '
  # normaliza quebras de linha
  s/\r\n/\n/g;
  s/\r/\n/g;

  # remove espaços em excesso
  s/[ \t]+$//mg;

  # corrige cabeçalhos duplicados
  s/^\#\#\#\#/\#\#\#/mg;
  s/^\#\#\#/\#\#/mg if /Ideias/;

  # poda de seções não essenciais
  for my $pat (qw(
    Metadados\ adicionais.*
    Sugest(ões|oes)\ de\ linkagem.*
    Insights?.*
    Conex(ões|oes).*
  )) {
    s/^\#\#\s*$pat\s*\n(?:.*?\n)(?=^\#\#\s|\z)//gms;
  }

' "$FILE" > "$TMP"

mv "$TMP" "$FILE"
