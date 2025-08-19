# Kickoff – 01_The_Character_of_Consciousness

## Referências (públicas no GitHub)
- Metodologia: https://github.com/mmenezes68/chatgpt-export/blob/main/docs/metodologia.md
- Ata 001: https://github.com/mmenezes68/chatgpt-export/blob/main/docs/atas/ata_001.md
- Ata 002: https://github.com/mmenezes68/chatgpt-export/blob/main/docs/atas/ata_002.md
- Índice de obras (YAML): https://github.com/mmenezes68/chatgpt-export/blob/main/docs/obras_index.yaml

## Caminhos locais (OneDrive)
- Base: `/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência`
- Obra: `/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência/01_The_Character_of_Consciousness`
- PT capítulos: `/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência/01_The_Character_of_Consciousness/pt/01_capitulos` (se aplicável)
- EN capítulos: `/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência/01_The_Character_of_Consciousness/en/01_chapters`

## Checklist inicial
- [ ] PT e EN com mesmo número de capítulos (Capítulo_* ↔ Chapter_*)
- [ ] Cada capítulo tem `00_intro.md` (PT/EN)
- [ ] PT: `Ideias_Principais.md`, `Conceitos_Chave.md`, `Questoes_Reflexao.md`, `Trechos_Relevantes.md`
- [ ] EN: `Main_Ideas.md`, `Key_Concepts.md`, `Reflection_Questions.md`, `Relevant_Passages.md`
- [ ] `scripts/generate_obras_index.sh` rodado e `docs/obras_index.yaml` atualizado
- [ ] Build ABNT OK

## Comandos úteis
### Atualizar índice
bash scripts/generate_obras_index.sh "/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência"

### Verificar 00_intro.md
find "/Users/marcosmenezes/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência/01_The_Character_of_Consciousness" -name "00_intro.md" -print

### Relatório ABNT (ajuste conforme seu fluxo)
bash projeto-obras/scripts-abnt/bin/relatorio_full.sh
# ou
bash projeto-obras/scripts-abnt/bin/gera_relatorio_bilingue.sh

## Próximos passos
1. Completar `00_intro.md` em todos os capítulos (PT/EN).
2. Preencher conteúdos base (ideias, conceitos, questões, trechos).
3. Rodar pipeline ABNT e validar PDF.
4. Registrar decisões na Ata 003.
