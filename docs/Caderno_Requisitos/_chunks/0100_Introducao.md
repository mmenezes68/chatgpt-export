# 1. Introdução

Este caderno define os **requisitos funcionais e técnicos** do projeto de tratamento de obras acadêmicas da **GOVPRO**, cobrindo: organização em Markdown (compatível com Obsidian), geração de relatórios em **ABNT** via **Pandoc + XeLaTeX**, suporte **bilíngue (PT/EN)**, automações de verificação e *build*, e integração com **GitHub**.

## 1.1 Propósito
Estabelecer um padrão claro e reproduzível para:
- Produzir e manter conteúdos em `.md` (PT/EN);
- Gerar PDFs com layout mínimo ABNT (capa, sumário, seções numeradas);
- Permitir evolução contínua por humanos e por GPT Business a partir deste repositório.

## 1.2 Escopo
Inclui:
- Estrutura de pastas por **obra** (PT/EN) e por **capítulo**;
- Regras de conteúdo e nomenclatura dos `.md`;
- Scripts de normalização de texto e *build* (Pandoc/XeLaTeX);
- Geração **bilíngue** sincronizada (quando existir conteúdo em EN);
- Verificações estáticas (linters/checks) e *Makefile* para uso local/CI.

Exclui:
- Macros ABNT completas e formatação tipográfica avançada;
- Gestão de referências bibliográficas complexas (será futura evolução).

## 1.3 Definições e Siglas
- **ABNT**: conjunto de normas brasileiras de formatação acadêmica.
- **Obsidian**: ferramenta de notas baseada em Markdown.
- **Pandoc**: conversor de documentos; aqui, para `.md` → `.pdf`.
- **XeLaTeX**: mecanismo LaTeX usado pelo Pandoc para PDF.
- **CI**: Integração Contínua (GitHub Actions).
- **PT/EN**: conteúdos em Português / Inglês.

## 1.4 Público-Alvo
- Autores e revisores de conteúdo;
- Mantenedores de scripts/devs;
- GPT Business, como agente de automação de *refactors* e *builds*.

## 1.5 Visão Geral do Documento
Os próximos capítulos detalham: objetivos, estrutura de `.md`, automações, integração com Obsidian e GitHub, requisitos ABNT mínimos, casos de uso (uma obra e múltiplas obras), e critérios de validação.

## 1.6 Premissas e Restrições
- Sistema alvo primário: **macOS** (bash/zsh, `iconv`, `perl`).
- **UTF-8** obrigatório em todos os `.md`.
- Remoção/normalização de caracteres problemáticos (NBSP, traços especiais, emojis).
- **Pandoc** e uma distribuição TeX com **XeLaTeX** instalados.
- Sem dependências proprietárias adicionais.

## 1.7 Entregáveis
- Estrutura de diretórios padrão por obra e capítulo (PT/EN);
- Scripts em `projeto-obras/scripts-abnt/bin`;
- Templates LaTeX mínimos (`abnt_header.tex`, `abnt_cover.tex`);
- **Caderno de Requisitos** (este documento) em `docs/Caderno_Requisitos/`.

## 1.8 Critérios de Pronto (DoD) — nível documento
- `.md` válidos (UTF-8, sem links não achatados nem seções proibidas);
- *Build* local gera PDF sem erros do LaTeX;
- Sumário presente; numeração de seções ativa;
- Conteúdo PT compila sempre; EN compila quando houver *seed/review*;
- CI executa *checks* e *build* mínimo sem erro (quando configurado).

