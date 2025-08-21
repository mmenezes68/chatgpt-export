#!/usr/bin/env bash
set -euo pipefail

# === Config ===
REAL_OBRA_DIR="${1:-/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência/01_The_Character_of_Consciousness}"
BIN="/Users/marcosmenezes/chatgpt-export/projeto-obras/scripts-abnt/bin"
TITLE_PT="${TITLE_PT:-Relatório de Leitura — The Character of Consciousness}"
AUTHOR="${AUTHOR:-Marcos Menezes}"
ADVISOR="${ADVISOR:-Prof. Dr. [Nome do Orientador]}"
ROOT_OUT="${ROOT_OUT:-$HOME/Relatorio_Consciousness}"

# === Descobrir capítulos PT ===
CAPS=()
if find "$REAL_OBRA_DIR" -maxdepth 1 -type d -name 'Capítulo_*' | grep -q .; then
  while IFS= read -r d; do CAPS+=("$(basename "$d")"); done < <(find "$REAL_OBRA_DIR" -maxdepth 1 -type d -name 'Capítulo_*' | sort)
elif find "$REAL_OBRA_DIR/pt/01_capitulos" -maxdepth 1 -type d -name 'Capítulo_*' | grep -q .; then
  while IFS= read -r d; do CAPS+=("$(basename "$d")"); done < <(find "$REAL_OBRA_DIR/pt/01_capitulos" -maxdepth 1 -type d -name 'Capítulo_*' | sort)
else
  echo "ERRO: não encontrei pastas 'Capítulo_*' em: $REAL_OBRA_DIR" >&2; exit 2
fi

# === Normalização global (tolerante) ===
[[ -x "$BIN/normalize_utf8.sh" ]] && bash "$BIN/normalize_utf8.sh" "$REAL_OBRA_DIR" || true

# === Monta OBRA TEMP no layout esperado pelo gerador ===
TMP_OBRA="$(mktemp -d -t obra_symlinks_XXXX)"
mkdir -p "$TMP_OBRA/pt/01_capitulos" "$TMP_OBRA/en/01_chapters"

# PT
if [[ -d "$REAL_OBRA_DIR/pt/01_capitulos" ]]; then
  rmdir "$TMP_OBRA/pt/01_capitulos"
  ln -s "$REAL_OBRA_DIR/pt/01_capitulos" "$TMP_OBRA/pt/01_capitulos"
else
  rmdir "$TMP_OBRA/pt/01_capitulos"
  ln -s "$REAL_OBRA_DIR" "$TMP_OBRA/pt/01_capitulos"
fi
# EN (se existir)
if [[ -d "$REAL_OBRA_DIR/en/01_chapters" ]]; then
  rmdir "$TMP_OBRA/en/01_chapters"
  ln -s "$REAL_OBRA_DIR/en/01_chapters" "$TMP_OBRA/en/01_chapters"
fi

# === Loop capítulo a capítulo ===
PT_PDFS=()
EN_PDFS=()
i=1
for CAP in "${CAPS[@]}"; do
  OUT_DIR="$ROOT_OUT/$CAP"; mkdir -p "$OUT_DIR"
  echo "==> [$i/${#CAPS[@]}] $CAP"

  PT_REAL="$REAL_OBRA_DIR/$CAP"
  [[ -d "$PT_REAL" ]] || PT_REAL="$REAL_OBRA_DIR/pt/01_capitulos/$CAP"
  [[ -x "$BIN/verify_md.sh" && -d "$PT_REAL" ]] && bash "$BIN/verify_md.sh" "$PT_REAL" || true

  EN_REAL="$REAL_OBRA_DIR/en/01_chapters/$(echo "$CAP" | sed 's/^Capítulo_/Chapter_/')"
  [[ -x "$BIN/verify_md.sh" && -d "$EN_REAL" ]] && bash "$BIN/verify_md.sh" "$EN_REAL" || true

  export OUT_DIR TITLE_PT AUTHOR ADVISOR
  [[ -x "$BIN/gera_relatorio_bilingue.sh" ]] || { echo "ERRO: $BIN/gera_relatorio_bilingue.sh não encontrado." >&2; exit 2; }
  bash "$BIN/gera_relatorio_bilingue.sh" --obra "$TMP_OBRA" --capitulos "$CAP"

  [[ -f "$OUT_DIR/Relatorio_PT.pdf" ]] && PT_PDFS+=("$OUT_DIR/Relatorio_PT.pdf")
  [[ -f "$OUT_DIR/Report_EN.pdf"    ]] && EN_PDFS+=("$OUT_DIR/Report_EN.pdf")

  i=$((i+1))
done

# === Concatenação (se disponível) ===
concat() {
  local out="$1"; shift; local files=( "$@" )
  [[ ${#files[@]} -gt 0 ]] || return 0
  mkdir -p "$(dirname "$out")"
  if command -v pdfunite >/dev/null 2>&1; then
    pdfunite "${files[@]}" "$out"
  elif command -v qpdf >/dev/null 2>&1; then
    local first="${files[0]}"; local rest=( "${files[@]:1}" )
    qpdf --empty --pages "$first" "${rest[@]}" -- "$out"
  else
    echo "⚠️  Sem pdfunite/qpdf; pulando concatenação: ${out##*/}."
  fi
}
# Só concatena se houver algo
((${#PT_PDFS[@]})) && concat "$ROOT_OUT/_final/Relatorio_PT_OBRA.pdf" "${PT_PDFS[@]}"
((${#EN_PDFS[@]})) && concat "$ROOT_OUT/_final/Report_EN_OBRA.pdf"   "${EN_PDFS[@]}"

echo
echo "✅ Concluído."
echo "→ Por capítulo: $ROOT_OUT/<Capítulo_*>/Relatorio_PT.pdf (e Report_EN.pdf quando houver)"
[[ ${#PT_PDFS[@]} -gt 0 ]] && echo "→ Final PT:   $ROOT_OUT/_final/Relatorio_PT_OBRA.pdf"
[[ ${#EN_PDFS[@]} -gt 0 ]] && echo "→ Final EN:   $ROOT_OUT/_final/Report_EN_OBRA.pdf" || echo "→ Final EN:   (não gerado; sem capítulos EN)"
