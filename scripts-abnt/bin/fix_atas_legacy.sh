#!/usr/bin/env bash
set -euo pipefail

for f in docs/atas/ata_00{1..6}.md; do
  [[ -f "$f" ]] || continue
  num=$(echo "$f" | sed -E 's/.*ata_([0-9]+)\.md/\1/')
  tmp="$f.tmp"

  cp "$f" "$tmp"

  # 1) Título canônico
  if ! grep -Eq '^# Ata [0-9]{3} — ' "$tmp"; then
    titulo_exist=$(head -n1 "$tmp" | sed 's/^# *//')
    [[ -z "$titulo_exist" || "$titulo_exist" =~ ^Ata ]] || titulo_exist="Reunião"
    {
      echo "# Ata ${num} — ${titulo_exist:-Reunião} — Projeto ICB-USP Consciência"
      echo
      sed '1d' "$tmp"
    } > "$tmp.new" && mv "$tmp.new" "$tmp"
  fi

  # 2) Campo Data
  if grep -Eq '^[Dd]ata:' "$tmp"; then
    sed -E -i '' 's/^[Dd]ata:/**Data:**/g' "$tmp"
  fi
  if ! grep -Eq '^\*\*Data:\*\*' "$tmp"; then
    # insere após a primeira linha de título
    awk 'NR==1{print; print ""; print "**Data:** —"; next} {print}' "$tmp" > "$tmp.new" && mv "$tmp.new" "$tmp"
  fi

  # 3) Seções obrigatórias (se faltar, adiciona no fim)
  add_section() {
    sec="$1"
    if ! grep -Eq "^## ${sec}\$" "$tmp"; then
      {
        echo
        echo "## ${sec}"
        case "$sec" in
          "1. Contexto") echo "Resumo/Contexto original da reunião."; ;;
          "2. Decisões") echo "- "; ;;
          "3. Ações (responsável → prazo)") echo "- [ ]  —  — YYYY-MM-DD"; ;;
          "4. Anexos / Referências") echo "- "; ;;
        esac
      } >> "$tmp"
    fi
  }

  add_section "1. Contexto"
  add_section "2. Decisões"
  add_section "3. Ações (responsável → prazo)"
  add_section "4. Anexos / Referências"

  mv "$tmp" "$f"
  echo "Corrigida: $f"
done
