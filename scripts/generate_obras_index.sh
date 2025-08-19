#!/usr/bin/env bash
set -euo pipefail

BASE_ONEDRIVE="${1:-/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência}"
OBRAS_GLOB="${2:-*}"
OUT_FILE="docs/obras_index.yaml"

yaml_escape() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }

count_chapters_pt() {
  local obra_dir="$1"; local c1=0 c2=0
  [[ -d "$obra_dir" ]] && c1=$(find "$obra_dir" -maxdepth 1 -type d -name 'Capítulo_*' 2>/dev/null | wc -l | tr -d ' ')
  [[ -d "$obra_dir/pt/01_capitulos" ]] && c2=$(find "$obra_dir/pt/01_capitulos" -maxdepth 1 -type d -name 'Capítulo_*' 2>/dev/null | wc -l | tr -d ' ')
  echo $(( c1 + c2 ))
}

count_chapters_en() {
  local obra_dir="$1"
  if [[ -d "$obra_dir/en/01_chapters" ]]; then
    find "$obra_dir/en/01_chapters" -maxdepth 1 -type d -name 'Chapter_*' 2>/dev/null | wc -l | tr -d ' '
  else
    echo 0
  fi
}

last_updated() {
  local obra_dir="$1"; local ts
  ts=$(
    find "$obra_dir" -type f \
      -not -path '*/.temp_relatorio/*' \
      -not -name '*.bak*' -print0 2>/dev/null |
    xargs -0 stat -f "%m %N" 2>/dev/null |
    sort -nr | head -n1 | awk '{print $1}' || true
  )
  [[ -n "${ts:-}" ]] && date -r "$ts" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || true
}

mkdir -p docs
{
  echo "# Gerado automaticamente por scripts/generate_obras_index.sh"
  echo "# Base OneDrive: $BASE_ONEDRIVE"
  echo "obras:"
} > "$OUT_FILE"

shopt -s nullglob
for obra_path in "$BASE_ONEDRIVE"/$OBRAS_GLOB; do
  [[ -d "$obra_path" ]] || continue
  obra_name="$(basename "$obra_path")"
  case "$obra_name" in 05_Modelos|99_Auxiliares|scripts-abnt|Zotero_PDFs|.obsidian) continue ;; esac

  pt_chapters="$(count_chapters_pt "$obra_path")"
  en_chapters="$(count_chapters_en "$obra_path")"
  updated="$(last_updated "$obra_path")"

  obra_esc="$(yaml_escape "$obra_name")"
  pt_esc="$(yaml_escape "$obra_path")"
  en_esc="$(yaml_escape "$obra_path/en/01_chapters")"
  upd_esc="$(yaml_escape "${updated:-}")"

  {
    echo "  - obra: \"$obra_esc\""
    echo "    path_pt: \"$pt_esc\""
    echo "    path_en: \"$en_esc\""
    echo "    chapters_pt: ${pt_chapters}"
    echo "    chapters_en: ${en_chapters}"
    echo "    last_updated: \"${upd_esc}\""
  } >> "$OUT_FILE"
done
shopt -u nullglob

echo "OK: índice gerado em $OUT_FILE"
