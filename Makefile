# Makefile — atalhos locais

PT_OBRA?=$(HOME)/Library/CloudStorage/OneDrive-Pessoal/USP/Projeto_ICB_Consciência/ICB-USP_Consciência/01_The_Character_of_Consciousness
PT_CAP?=Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness

BIN=projeto-obras/scripts-abnt/bin

.PHONY: check build-pt build-en build-both

check:
	@$(BIN)/verify_md.sh "$(PT_OBRA)/pt/01_capitulos/$(PT_CAP)" || exit $$?

build-pt:
	@$(BIN)/relatorio_full.sh \
	  --obra  "$(PT_OBRA)" \
	  --capitulos "$(PT_CAP)" \
	  --title "Relatório de Leitura" \
	  --author "Marcos Antonio de Menezes" \
	  --advisor "Prof. Walter Chesnut" \
	  --out "$(HOME)/Relatorio_PT_TESTE.pdf"

build-en:
	@LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
	$(BIN)/relatorio_full.sh \
	  --obra  "$(PT_OBRA)" \
	  --capitulos "$(PT_CAP)" \
	  --title "Reading Report" \
	  --author "Marcos Antonio de Menezes" \
	  --advisor "Prof. Walter Chesnut" \
	  --out "$(HOME)/Report_EN_TESTE.pdf"

build-both:
	@$(BIN)/gera_relatorio_bilingue.sh \
	  --obra  "$(PT_OBRA)" \
	  --capitulos "$(PT_CAP)" \
	  --author "Marcos Antonio de Menezes" \
	  --advisor "Prof. Walter Chesnut"
