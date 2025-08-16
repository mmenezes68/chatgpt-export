#!/usr/bin/env bash
# Reencode para UTF-8 com detecção + fallbacks típicos (macOS).
set -euo pipefail

detect_charset() {
  # Tenta detectar via `file -I` (macOS/BSD); retorna algo como 'utf-8', 'iso-8859-1' etc.
  if command -v file >/dev/null 2>&1; then
    # Saída: text/plain; charset=utf-8
    local mime; mime="$(file -I "$1" 2>/dev/null || true)"
    printf '%s\n' "$mime" | sed -n 's/.*charset=\(.*\)$/\1/p' | tr '[:upper:]' '[:lower:]'
  else
    echo ""
  fi
}

recode_if_needed() {
  local f="$1"
  # Já é UTF-8 válido?
  if iconv -f UTF-8 -t UTF-8 "$f" > /dev/null 2>&1; then
    return 0
  fi

  local tmp; tmp="$(mktemp)"
  local tried=()

  # Se detecção sugerir um charset específico, tenta primeiro
  local guess; guess="$(detect_charset "$f" || true)"
  if [[ -n "$guess" && "$guess" != "utf-8" ]]; then
    tried+=("$guess")
    if iconv -f "$guess" -t UTF-8 "$f" -o "$tmp" 2>/dev/null; then
      mv "$tmp" "$f"; echo "→ Reencode: $f ($guess → utf-8)"; return 0
    fi
  fi

  # Fallbacks comuns
  for enc in ISO-8859-1 WINDOWS-1252 MACROMAN; do
    tried+=("$enc")
    if iconv -f "$enc" -t UTF-8 "$f" -o "$tmp" 2>/dev/null; then
      mv "$tmp" "$f"; echo "→ Reencode: $f ($enc → utf-8)"; return 0
    fi
  done

  rm -f "$tmp"
  echo "⚠️  Não foi possível recodificar $f automaticamente (tentado: ${tried[*]})." >&2
  return 0
}

for f in "$@"; do
  [[ -f "$f" ]] || continue
  recode_if_needed "$f"
done
