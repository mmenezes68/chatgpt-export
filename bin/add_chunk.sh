#!/usr/bin/env bash
set -euo pipefail
DIR="docs/Caderno_Requisitos/_chunks"
mkdir -p "$DIR"

title="${1:-Sem titulo}"
count=$(ls -1 "$DIR" 2>/dev/null | wc -l | awk '{print $1+1}')
n=$(printf "%04d" "$count")
safe=$(printf "%s" "$title" | tr ' ' '_' | tr -cd '[:alnum:]_-' )
file="$DIR/${n}_${safe}.md"

pbpaste | sed -f bin/clean_terminal_noise.sed > "$file"

if ! head -n1 "$file" | grep -q '^#'; then
  { printf "# %s\n\n" "$title"; cat "$file"; } > "$file.tmp" && mv "$file.tmp" "$file"
fi

echo "-> chunk criado: $file"
