#!/usr/bin/env bash
set -euo pipefail

REPO="/Users/marcosmenezes/chatgpt-export"
OUT_DIR="$REPO/docs"
TS="$(date +%Y%m%d_%H%M%S)"
OUT_FILE="$OUT_DIR/inspecao_relatorio_$TS.txt"

section() { printf "\n==== %s ====\n" "$*"; }

mkdir -p "$OUT_DIR"
: > "$OUT_FILE"

{
  section "Contexto"
  echo "Repo: $REPO"
  echo "Gerado em: $(date)"
  echo

  section "Metodologia (docs/metodologia.md)"
  if [[ -f "$REPO/docs/metodologia.md" ]]; then
    echo "Caminho: docs/metodologia.md"
    echo "-- Trechos com palavras-chave (ABNT|relat(ó|o)rio|bil[ií]ngue|LaTeX|Pandoc):"
    LC_ALL=C grep -nE 'ABNT|[Rr]elat[oó]rio|bil[ií]ngue|LaTeX|Pandoc' "$REPO/docs/metodologia.md" || true
  else
    echo "NÃO ENCONTRADO: docs/metodologia.md"
  fi

  section "Atas (docs/atas/*.md)"
  if compgen -G "$REPO/docs/atas/*.md" >/dev/null; then
    ls -1 "$REPO/docs/atas"/*.md
    echo
    for f in "$REPO"/docs/atas/*.md; do
      echo "-- $f"
      LC_ALL=C grep -nE 'ABNT|[Rr]elat[oó]rio|bil[ií]ngue|LaTeX|Pandoc|Obsidian|consolidad' "$f" || true
      echo
    done
  else
    echo "NÃO ENCONTRADO: docs/atas/*.md"
  fi

  section "Scripts de relatório (projeto-obras/scripts-abnt/bin)"
  BIN_DIR="$REPO/projeto-obras/scripts-abnt/bin"
  if [[ -d "$BIN_DIR" ]]; then
    ls -1 "$BIN_DIR" || true
    echo
    for s in "$BIN_DIR"/*; do
      [[ -f "$s" ]] || continue
      echo "-- $s"
      head -n 30 "$s" || true
      echo ">>> Ocorrências (relat|tex|pdf|pandoc|latex|abnt):"
      LC_ALL=C grep -nE 'relat|tex|pdf|pandoc|latex|abnt' "$s" || true
      echo
    done
  else
    echo "NÃO ENCONTRADO: $BIN_DIR"
  fi

  section "Templates LaTeX (projeto-obras/scripts-abnt/templates)"
  TPL_DIR="$REPO/projeto-obras/scripts-abnt/templates"
  if [[ -d "$TPL_DIR" ]]; then
    ls -1 "$TPL_DIR" || true
    echo
    for t in "$TPL_DIR"/*; do
      [[ -f "$t" ]] || continue
      echo "-- $t"
      head -n 20 "$t" || true
      echo
    done
  else
    echo "NÃO ENCONTRADO: $TPL_DIR"
  fi

  section "Index de Obras (docs/obras_index.yaml)"
  if [[ -f "$REPO/docs/obras_index.yaml" ]]; then
    sed -n '1,120p' "$REPO/docs/obras_index.yaml"
    echo
    echo "-- Filtro p/ The_Character_of_Consciousness:"
    LC_ALL=C grep -n "The_Character_of_Consciousness" "$REPO/docs/obras_index.yaml" || true
  else
    echo "NÃO ENCONTRADO: docs/obras_index.yaml"
  fi

  section "Checklist sintético (derivado das ocorrências)"
  cat <<'CHK'
- Metodologia define fluxo (capítulos PT/EN e arquivo introdutório por capítulo).
- Atas mencionam: consolidação em relatório ABNT; bilíngue quando aplicável; interlinks Obsidian.
- Scripts bin/ indicam geração LaTeX/PDF; verificar parâmetros de entrada/saída e nomes esperados.
- Templates abnt_* definem capa/cabeçalho — checar se campos (autor, título, data, obra) estão corretos.
- Conferir paths no obras_index.yaml (pt/en) antes de gerar.
- Validações: todos capítulos com 00_intro.md; arquivo(s) principais preenchidos (sem placeholders).
CHK

} | tee "$OUT_FILE"

echo
echo "✅ Inspeção concluída."
echo "► Resultado salvo em: $OUT_FILE"
