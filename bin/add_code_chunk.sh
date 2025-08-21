#!/usr/bin/env bash
set -euo pipefail
DIR="docs/Caderno_Requisitos/_chunks"
mkdir -p "$DIR"

lang="${1:-bash}"
title="${2:-Codigo}"
count=$(ls -1 "$DIR" 2>/dev/null | wc -l | awk '{print $1+1}')
n=$(printf "%04d" "$count")
safe=$(printf "%s" "$title" | tr ' ' '_' | tr -cd '[:alnum:]_-' )
file="$DIR/${n}_code_${safe}.md"

{
  printf "# %s\n\n" "$title"
  printf '```%s\n' "$lang"
  pbpaste | sed -f bin/clean_terminal_noise.sed
  printf '\n```\n'
} > "$file"

echo "-> code chunk criado: $file"
