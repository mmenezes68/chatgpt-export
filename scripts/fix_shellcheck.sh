#!/usr/bin/env bash
set -euo pipefail

fix_file() {
  local file="$1" rules="$2"
  [[ -f "$file" ]] || { echo "Arquivo não encontrado: $file"; return 1; }

  local first rest shebang body head5 disable_line body_no_disable new_content
  first="$(head -n1 "$file" || true)"
  rest="$(tail -n +2 "$file" 2>/dev/null || true)"

  if [[ "$first" =~ ^#! ]]; then
    shebang="$first"
    body="$rest"
  else
    shebang='#!/bin/bash'
    body="$(cat "$file")"
  fi

  disable_line="# shellcheck disable=$(echo "$rules" | sed 's/[ ,]\+/,/g')"

  head5="$(printf "%s\n%s\n" "$shebang" "$body" | head -n5)"
  if printf "%s" "$head5" | grep -q 'shellcheck disable='; then
    body_no_disable="$(printf "%s\n%s\n" "$shebang" "$body" | tail -n +2 | sed '/shellcheck disable=/d')"
    new_content="$(printf "%s\n%s\n%s\n" "$shebang" "$disable_line" "$body_no_disable")"
  else
    new_content="$(printf "%s\n%s\n%s\n" "$shebang" "$disable_line" "$body")"
  fi

  printf "%s" "$new_content" > "$file"
  chmod +x "$file"
  echo "Corrigido: $file  →  $disable_line"
}

fix_file "projeto-obras/scripts-abnt/bin/relatorio_full.sh" "SC2020,SC2016"
fix_file "projeto-obras/scripts-abnt/bin/gera_relatorio_bilingue.sh" "SC2034"

echo "OK: ajustes aplicados."
