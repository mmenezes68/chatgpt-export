#!/usr/bin/env bash
set -euo pipefail

# === Parâmetros ===
OBRA_SLUG="${1:-01_The_Character_of_Consciousness}"
BASE_ONEDRIVE="${2:-/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência}"
OBRA_PATH="${BASE_ONEDRIVE}/${OBRA_SLUG}"

# === Links públicos no GitHub ===
REPO_WEB="https://github.com/mmenezes68/chatgpt-export"
URL_METODO="${REPO_WEB}/blob/main/docs/metodologia.md"
URL_ATA1="${REPO_WEB}/blob/main/docs/atas/ata_001.md"
URL_ATA2="${REPO_WEB}/blob/main/docs/atas/ata_002.md"
URL_INDEX_YAML="${REPO_WEB}/blob/main/docs/obras_index.yaml"

# === Verificações básicas ===
if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "⚠️  Rode dentro da raiz do repositório Git."
  exit 1
fi
REPO_ROOT="$(git rev-parse --show-toplevel)"

if [[ ! -d "$OBRA_PATH" ]]; then
  echo "⚠️  Obra não encontrada em: $OBRA_PATH"
  echo "    Ajuste BASE_ONEDRIVE ou OBRA_SLUG."
  exit 1
fi

# === Gera README_kickoff.md da obra ===
OUT_DIR="${REPO_ROOT}/docs/obras/${OBRA_SLUG}"
mkdir -p "$OUT_DIR"
OUT_FILE="${OUT_DIR}/README_kickoff.md"

cat > "$OUT_FILE" <<EOF
# Kickoff – ${OBRA_SLUG}

## Referências (públicas no GitHub)
- Metodologia: ${URL_METODO}
- Ata 001: ${URL_ATA1}
- Ata 002: ${URL_ATA2}
- Índice de obras (YAML): ${URL_INDEX_YAML}

## Caminhos locais (OneDrive)
- Base: \`${BASE_ONEDRIVE}\`
- Obra: \`${OBRA_PATH}\`
- PT capítulos: \`${OBRA_PATH}/pt/01_capitulos\` (se aplicável)
- EN capítulos: \`${OBRA_PATH}/en/01_chapters\`

## Checklist inicial
- [ ] PT e EN com mesmo número de capítulos (Capítulo_* ↔ Chapter_*)
- [ ] Cada capítulo tem \`00_intro.md\` (PT/EN)
- [ ] PT: \`Ideias_Principais.md\`, \`Conceitos_Chave.md\`, \`Questoes_Reflexao.md\`, \`Trechos_Relevantes.md\`
- [ ] EN: \`Main_Ideas.md\`, \`Key_Concepts.md\`, \`Reflection_Questions.md\`, \`Relevant_Passages.md\`
- [ ] \`scripts/generate_obras_index.sh\` rodado e \`docs/obras_index.yaml\` atualizado
- [ ] Build ABNT OK

## Comandos úteis
### Atualizar índice
bash scripts/generate_obras_index.sh "${BASE_ONEDRIVE}"

### Verificar 00_intro.md
find "${OBRA_PATH}" -name "00_intro.md" -print

### Relatório ABNT (ajuste conforme seu fluxo)
bash projeto-obras/scripts-abnt/bin/relatorio_full.sh
# ou
bash projeto-obras/scripts-abnt/bin/gera_relatorio_bilingue.sh

## Próximos passos
1. Completar \`00_intro.md\` em todos os capítulos (PT/EN).
2. Preencher conteúdos base (ideias, conceitos, questões, trechos).
3. Rodar pipeline ABNT e validar PDF.
4. Registrar decisões na Ata 003.
EOF

echo "✅ Kickoff gerado em: ${OUT_FILE}"
echo
BRANCH="feat/${OBRA_SLUG// /_}-kickoff"
echo "👉 Opcional (branch + commit):"
echo "   git checkout -b ${BRANCH}"
echo "   git add ${OUT_FILE}"
echo "   git commit -m \"docs(${OBRA_SLUG}): kickoff e checklist inicial\""
echo "   git push origin ${BRANCH}"
