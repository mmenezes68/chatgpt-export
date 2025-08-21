#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
OUT="$REPO/SCRIPTS_INDEX.md"
BASES=("$REPO/scripts" "$REPO/scripts-abnt")

# Cabeçalho
{
  echo "# Índice de Scripts"
  echo
  echo "| Nome | Caminho | Resumo | Como executar |"
  echo "|---|---|---|---|"
} > "$OUT"

list_files () {
  for B in "${BASES[@]}"; do
    [ -d "$B" ] || continue
    # Lista com NUL para suportar espaços
    find "$B" -type f \( -name "*.sh" -o -name "*.bash" -o -name "*.zsh" -o -name "*.py" -o -name "Makefile" \) \
      -not -path "*/.git/*" -print0
  done | sort -z
}

# Linhas (lendo NUL-terminated)
while IFS= read -r -d '' f; do
  rel="${f#$REPO/}"
  base="$(basename "$f")"
  name="$base"
  summary="—"
  usage="bash $rel"

  # NAME/TITLE
  n1="$(grep -m1 -E '^\s*(#|//)\s*(NAME|TITLE|Name|Title):' "$f" 2>/dev/null || true)"
  if [ -n "${n1:-}" ]; then
    name="$(sed -E 's/^\s*(#|\/\/)\s*(NAME|TITLE|Name|Title):\s*//' <<<"$n1")"
  fi

  # SUMMARY/DESCRIPTION/RESUMO
  s1="$(grep -m1 -E '^\s*(#|//)\s*(SUMMARY|DESCRIPTION|RESUMO|Summary|Description|Resumo):' "$f" 2>/dev/null || true)"
  if [ -n "${s1:-}" ]; then
    summary="$(sed -E 's/^\s*(#|\/\/)\s*(SUMMARY|DESCRIPTION|RESUMO|Summary|Description|Resumo):\s*//' <<<"$s1")"
  else
    s2="$(grep -m1 -E '^\s*(#|//)\s+[^ ]' "$f" 2>/dev/null | sed -E 's/^\s*(#|\/\/)\s*//' || true)"
    [ -n "${s2:-}" ] && summary="$s2"
  fi

  # Uso sugerido
  case "$base" in
    Makefile|makefile|Makefile.*) usage="make -f $rel";;
    *.py)  usage="python3 $rel";;
    *.zsh) usage="zsh $rel";;
    *.bash)usage="bash $rel";;
    *.sh)  usage="bash $rel";;
  esac

  # Escapar '|'
  name="${name//|/-}"
  summary="${summary//|/-}"
  usage="${usage//|/-}"
  rel_show="${rel//|/-}"

  printf '| %s | %s | %s | `%s` |\n' "$name" "$rel_show" "$summary" "$usage" >> "$OUT"
done < <(list_files)

# Stage sempre; commit se mudou
git -C "$REPO" add "$OUT"
if ! git -C "$REPO" diff --cached --quiet -- "$OUT"; then
  git -C "$REPO" commit -m "docs(scripts): gerar/atualizar SCRIPTS_INDEX.md"
  echo "✔ Index atualizado e commitado."
else
  echo "ℹ Nenhuma mudança em $OUT."
fi
