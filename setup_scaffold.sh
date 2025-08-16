#!/usr/bin/env bash
set -euo pipefail

# [0] Verificações
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Rode este script dentro da raiz do repositório git (onde existe .git/)."
  exit 1
fi

# [1] Pastas-base
mkdir -p projeto-obras/scripts-abnt
mkdir -p projeto-obras/obras
mkdir -p projeto-obras/docs

# [2] README da documentação
printf '%s\n' "# Documentação e instruções do projeto" > projeto-obras/docs/README.md

# [3] README principal
cat > projeto-obras/README.md <<'EOF'
# Projeto Obras

Este diretório concentra todos os arquivos, scripts e documentos necessários para
tratar obras acadêmicas, organizar no Obsidian e gerar relatórios formatados segundo a ABNT.

## Estrutura

- **scripts-abnt/** — Scripts e templates para processamento de obras.
- **obras/** — Obras tratadas, separadas por idioma e por capítulo.
- **docs/** — Documentação do projeto e instruções.

## Fluxo Básico
1. Colocar o PDF original em `obras/Nome_da_Obra/raw/`.
2. Usar scripts em `scripts-abnt` para fracionar, tratar e gerar `.md`.
3. Editar e traduzir para PT/EN.
4. Gerar relatório ABNT final em PDF.
EOF

# [4] .gitkeep p/ versionar diretórios vazios
: > projeto-obras/scripts-abnt/.gitkeep
: > projeto-obras/obras/.gitkeep

# [5] Esqueleto bilíngue de exemplo
mkdir -p "projeto-obras/obras/Modelo_Obra/raw"

mkdir -p "projeto-obras/obras/Modelo_Obra/pt/00_front-matter"
mkdir -p "projeto-obras/obras/Modelo_Obra/pt/01_capitulos"
mkdir -p "projeto-obras/obras/Modelo_Obra/pt/02_notas"
mkdir -p "projeto-obras/obras/Modelo_Obra/pt/99_back-matter"

mkdir -p "projeto-obras/obras/Modelo_Obra/en/00_front-matter"
mkdir -p "projeto-obras/obras/Modelo_Obra/en/01_chapters"
mkdir -p "projeto-obras/obras/Modelo_Obra/en/02_notes"
mkdir -p "projeto-obras/obras/Modelo_Obra/en/99_back-matter"

: > "projeto-obras/obras/Modelo_Obra/pt/00_front-matter/README.md"
: > "projeto-obras/obras/Modelo_Obra/en/00_front-matter/README.md"

# [6] Commit e (tentar) push
git add -A
if git diff --cached --quiet; then
  echo "ℹ️  Nada novo para commitar."
else
  git commit -m "Scaffold: projeto-obras (scripts-abnt, obras, docs) + modelo bilíngue"
  # tenta push; se falhar por falta de upstream, configura
  if ! git push; then
    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    echo "⏳ Configurando upstream para a branch $CURRENT_BRANCH..."
    git push --set-upstream origin "$CURRENT_BRANCH"
  fi
fi

echo "✅ Estrutura criada/atualizada em: projeto-obras"
