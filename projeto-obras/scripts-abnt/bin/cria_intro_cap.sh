#!/usr/bin/env bash
set -euo pipefail
if [ $# -lt 3 ]; then
  echo "uso: $0 CAMINHO_BASE lingua(pt|en) NOME_DA_PASTA_DO_CAPITULO"
  exit 2
fi
BASE="$1"; LANG="$2"; CAP="$3"
case "$LANG" in
  pt) CAPDIR="$BASE/pt/01_capitulos/$CAP" ;;
  en) CAPDIR="$BASE/en/01_chapters/$CAP"  ;;
  *)  echo "lingua deve ser pt ou en"; exit 2;;
esac
mkdir -p "$CAPDIR"
FILE="$CAPDIR/00_intro.md"
if [ "$LANG" = "pt" ]; then
  cat > "$FILE" <<'MD'
# Introdução ao capítulo
Este capítulo apresenta o tema, objetivos de leitura e a lógica dos tópicos a seguir.
- **Contexto:** …
- **Objetivos:** …
- **Estrutura:** …

> Observação: esta introdução serve para situar o leitor antes dos itens detalhados.
MD
else
  cat > "$FILE" <<'MD'
# Chapter introduction
This chapter introduces the topic, reading goals, and the logic of the upcoming sections.
- **Context:** …
- **Goals:** …
- **Structure:** …

> Note: this introduction situates the reader before the detailed items.
MD
fi
echo "OK: criado $FILE"
