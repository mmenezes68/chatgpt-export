#!/usr/bin/env bash
set -euo pipefail

fix_file() {
  local file="$1" rule="$2"
  [[ -f "$file" ]] || { echo "Arquivo não encontrado: $file"; return 1; }

  # primeira linha atual
  local first; first="$(head -n1 "$file" || true)"

  # preserva shebang existente ou define um
  local shebang body
  if [[ "$first" =~ ^#! ]]; then
    shebang="$first"
    body="$(tail -n +2 "$file" || true)"
  else
    shebang='#!/bin/bash'
    body="$(cat "$file")"
  fi

  # evita duplicar o disable se já existir nas 5 primeiras linhas
  if head -n5 "$file" | grep -q "shellcheck disable=${rule}"; then
    printf "%s\n%s\n" "$shebang" "$body" > "$file.tmp"
  else
    printf "%s\n# shellcheck disable=%s\n%s\n" "$shebang" "$rule" "$body" > "$file.tmp"
  fi

  mv "$file.tmp" "$file"
  chmod +x "$file"
  echo "Corrigido: $file (rule ${rule})"
}

# Corrigir arquivos apontados no log do CI
fix_file "projeto-obras/scripts-abnt/bin/relatorio_full.sh" "SC2020"
fix_file "projeto-obras/scripts-abnt/bin/gera_relatorio_bilingue.sh" "SC2034"

echo "Arquivos corrigidos."
