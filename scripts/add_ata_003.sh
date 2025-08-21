#!/usr/bin/env bash
set -euo pipefail

REPO="/Users/marcosmenezes/chatgpt-export"
DEST_DIR="$REPO/docs/atas"
DEST_FILE="$DEST_DIR/ata_003.md"

mkdir -p "$DEST_DIR"

cat > "$DEST_FILE" <<'EOF'
---
titulo: "Ata 003 — Correção do Capítulo 1"
data: "2025-08-19"
participantes: ["Marcos Menezes", "Agente GPT"]
obra: "The Character of Consciousness"
capitulo: "01 — Facing Up to the Problem of Consciousness"
decisoes:
  - Identificado que o arquivo `00_intro.md` (PT e EN) estava incompleto, contendo apenas placeholders.
  - Confirmada a estrutura correta de diretórios (Capítulo_01 em PT; Chapter_01 em EN).
  - Decidiu-se substituir os arquivos `00_intro.md` por versões completas, fiéis ao PDF da obra.
  - Gerada versão integral em inglês (`00_intro_en.md`) com texto limpo do PDF.
  - Gerada versão em português (`00_intro_pt.md`) com tradução acadêmica, mantendo precisão conceitual e clareza filosófica.
  - Mantida a estrutura YAML e títulos padronizados, conforme metodologia do repositório.
  - Adotado procedimento de conferência após cada conversão para evitar perda de conteúdo.
  - Estabelecido que **todos os arquivos `.md` da obra passarão por revisão completa**, assegurando formatação padronizada para uso no **Obsidian**.
  - Confirmado que, ao final, todos os capítulos serão **consolidados em um relatório único**, estruturado segundo as **normas da ABNT/USP**.
  - O relatório permitirá **navegação integrada no Obsidian**, com interlinks entre ideias do mesmo capítulo, entre capítulos da mesma obra e também entre obras distintas.
proximos_passos:
  - Aplicar o mesmo processo aos capítulos subsequentes.
  - Garantir consistência terminológica entre as versões PT e EN.
  - Integrar conceitos e interlinks nas notas auxiliares (Conceitos_Chave, Ideias_Principais, Questoes_Reflexao, Trechos_Relevantes).
  - Planejar a geração automática dos relatórios ABNT monolíngue e bilíngue a partir dos `.md`.
---

# Ata 003 — Correção do Capítulo 1

Revisão do **Capítulo 1 — Facing Up to the Problem of Consciousness** da obra *The Character of Consciousness*.  

Foram substituídos os placeholders por versões completas em português e inglês, assegurando conformidade com a metodologia definida em `docs/metodologia.md`.  

Ficou estabelecido que todos os capítulos terão seus arquivos `.md` revisados e formatados de acordo com o modelo padronizado, garantindo utilização plena no **Obsidian**.  
Esses arquivos permitirão **navegar e interligar ideias** dentro da mesma obra e entre diferentes obras.  

Ao final, os capítulos serão **consolidados em um relatório conforme as normas da ABNT/USP**, de forma a servir tanto como documento acadêmico formal quanto como base de conhecimento navegável no Obsidian.
EOF

cd "$REPO"
git checkout main
git pull origin main
git add "$DEST_FILE"
git commit -m "docs: adicionar ata 003 — correção do Capítulo 1 (The Character of Consciousness)"
git push origin main

echo "✅ Ata 003 criada em: $DEST_FILE e enviada para o GitHub (branch main)."
