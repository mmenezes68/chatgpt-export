# 4. Organização dos Arquivos Markdown

Este capítulo padroniza os `.md` para compatibilidade com Obsidian e os scripts de automação (linters e Pandoc/XeLaTeX).

## 4.1 Estrutura Básica
Cada `.md` deve conter:
- **Título principal** (`#`).
- Subseções hierárquicas (`##`, `###`, `####`) sem pular níveis.
- Parágrafos curtos separados por linha em branco.
- Listas (numeradas e não-numeradas), citações (`>`), e blocos de código (```) quando necessário.

Exemplo mínimo:
```markdown
# Introdução

Este é um parágrafo.

## Ideias Principais
1. Primeiro ponto.

> Citação.

```bash
echo "exemplo"## 4.2 Boas Práticas
- Codificação **UTF-8** obrigatória (use `normalize_utf8.sh`).
- Evitar NBSP (U+00A0) e traços especiais (–, —); os scripts normalizam, mas mantenha limpo.
- Não numere manualmente cabeçalhos (a numeração vem do Pandoc).
- Mantenha alinhamento semântico entre PT e EN (mesma lógica de seções).

## 4.3 Metadados (opcional)
Cabeçalho YAML no topo pode ser usado:
```yaml
---
title: "Capítulo 1 — Facing Up to the Problem of Consciousness"
author: "David Chalmers"
language: "pt"
tags: ["consciência", "filosofia"]
---4.4 Nomenclatura
	•	Arquivos por capítulo (PT): 00_intro.md, 01_ideias_principais.md, 02_conceitos_chave.md, 03_questoes_reflexao.md, 04_trechos_relevantes.md.
	•	EN: 00_intro.md, 01_main_ideas.md, 02_key_concepts.md, 03_reflection_questions.md, 04_relevant_passages.md.
	•	Use _ (underscore) em vez de espaços.

4.5 Conteúdo Proibido no PDF
	•	Seções de apoio ao trabalho interno (p.ex. “Conexões/Conexoes”, “Metadados adicionais”, “Sugestões de linkagem”, “Insights”).
	•	Links “vivos” no formato wiki [[...]] ou markdown [texto](url) devem ser achatados para texto simples antes do build.

4.6 Benefícios
	•	Compatibilidade total com Obsidian.
	•	Build previsível com Pandoc.
	•	Menos atrito para o GPT Business refatorar e para revisores humanos avaliarem.
