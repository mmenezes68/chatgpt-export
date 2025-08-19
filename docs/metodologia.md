# Metodologia do Projeto -- Obras de Consciência

Este documento define o fluxo de trabalho padronizado para análise e
documentação das obras, servindo como guia para todos os projetos
derivados.

------------------------------------------------------------------------

## 1. Estrutura de Diretórios

Cada obra deve seguir a mesma estrutura:

    ICB-USP_Consciência/
      01_The_Character_of_Consciousness/
        pt/
          01_capitulos/
            Capítulo_01_Titulo/
              01_titulo.md       # Introdução/título do capítulo
              ...
            Capítulo_02_.../
            ...
        en/
          01_chapters/
            Chapter_01_Title/
            ...

-   `pt/` → versão em português.\
-   `en/` → versão em inglês.\
-   Cada capítulo **deve ter um arquivo introdutório `.md`** com o
    título/subtítulo.

------------------------------------------------------------------------

## 2. Organização do Repositório GitHub

-   **OneDrive** → guarda os **dados brutos** (obras digitalizadas,
    capítulos).\
-   **GitHub** → guarda os **scripts, documentação, atas e relatórios**.

> Decisão registrada em ata 002: separar dados brutos (OneDrive) de
> documentação e scripts (GitHub).

------------------------------------------------------------------------

## 3. Registro em Atas

-   Cada reunião/decisão gera uma ata (`docs/atas/ata_XXX.md`).\
-   Participantes: Marcos Menezes e agente ChatGPT.\
-   Estrutura padrão: data, participantes, decisões, próximos passos.\
-   Atas são versionadas no GitHub com branch `docs/ata-XXX`.

------------------------------------------------------------------------

## 4. Scripts

### 4.1 Correção de Shellcheck

-   `scripts/fix_shellcheck.sh` → ajusta headers dos scripts (`shebang`,
    regras desabilitadas como SC2020, SC2016, SC2034).

### 4.2 Geração de Índice de Obras

-   `scripts/generate_obras_index.sh` → percorre diretórios no OneDrive
    e gera `docs/obras_index.yaml` com:
    -   nome da obra
    -   caminhos `pt` e `en`
    -   número de capítulos
    -   data da última atualização

------------------------------------------------------------------------

## 5. Relatórios

-   Relatórios no estilo ABNT são gerados via scripts em
    `projeto-obras/scripts-abnt/bin/`.
-   Tipos principais:
    -   `relatorio_full.sh` → relatório completo de uma obra.\
    -   `gera_relatorio_bilingue.sh` → relatório bilíngue (pt/en).

------------------------------------------------------------------------

## 6. Fluxo de Trabalho

1.  Criar diretório da nova obra no OneDrive.\
2.  Inserir capítulos em `pt/01_capitulos` e `en/01_chapters`.\
3.  Executar `scripts/generate_obras_index.sh` para atualizar índice.\
4.  Documentar decisões em ata (`docs/atas/ata_XXX.md`).\
5.  Versionar scripts e atas no GitHub.\
6.  Gerar relatório ABNT com os scripts disponíveis.\
7.  Repetir o processo para a próxima obra.

------------------------------------------------------------------------

## 7. Reutilização

-   Este documento define a metodologia padrão.\
-   Para novos chats/projetos, basta referenciar **este arquivo** para
    garantir consistência.

------------------------------------------------------------------------

✍️ **Última atualização:** 2025-08-19
