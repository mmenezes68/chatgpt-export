# REQUIREMENTS — Projeto Obras (ABNT + Obsidian)

## 1. Escopo
Pipeline para: (a) organizar uma obra em PT/EN, (b) produzir `.md` compatíveis com Obsidian, (c) gerar relatório ABNT em PDF com Pandoc/XeLaTeX.

## 2. Estrutura de diretórios (por obra)
obras/
  Nome_da_Obra/
    raw/
    pt/
      00_front-matter/
      01_capitulos/
        Capítulo_XX_.../
          00_intro.md
          Conceitos_Chave.md
          Ideias_Principais.md
          Questoes_Reflexao.md
          Trechos_Relevantes.md
      02_notas/
      99_back-matter/
    en/
      00_front-matter/
      01_chapters/
        Chapter_XX_.../
          00_intro.md
          Key_Concepts.md
          Main_Ideas.md
          Reflection_Questions.md
          Relevant_Passages.md
      02_notes/
      99_back-matter/

## 3. Regras de conteúdo (.md)
- Títulos `#`, `##`, `###` sem estilos ad-hoc.
- **Proibidos**: “Conexões/Conexoes”, “Metadados adicionais”, “Sugestões de linkagem”, “Insights”.
- Cada capítulo começa com `00_intro.md` (contexto/objetivos/estrutura).
- Links:
  - `[[alvo|texto]]` → texto
  - `[[alvo]]` → alvo
  - `[texto](url)` → texto
- Remover front-matter YAML de topo (`--- ... ---`).

## 4. Normalização
- NBSP (U+00A0) → espaço normal.
- Hífens U+2011/U+2013/U+2014 → `-`.
- Remover VS16 (U+FE0F), emojis e controles C0/C1.
- Finais de linha `\n` (LF).

## 5. Build (baseline)
- `xelatex` via Pandoc, TOC ativo, `toc-depth=2`.
- Numeração `secnumdepth=1`.
- Capa (sem numeração), sumário e conteúdo.
- Templates:
  - `scripts-abnt/templates/abnt_header.tex`
  - `scripts-abnt/templates/abnt_cover.tex`

## 6. Scripts (CLI)
- `scripts-abnt/bin/normalize_text.sh FILE...`
- `scripts-abnt/bin/reencode_utf8.sh FILE...`
- `scripts-abnt/bin/relatorio_full.sh --obra DIR --capitulos "Capítulo_X" --title T --author A --advisor B --out OUT.pdf`
- `scripts-abnt/bin/gera_relatorio.sh` (wrapper)
- `scripts-abnt/bin/gera_relatorio_bilingue.sh` (PT + EN se existir)
- `scripts-abnt/bin/seed_en_from_pt.sh OBRA_DIR CAP_PT`
- `scripts-abnt/bin/cria_obra.sh Nome_Obra`
- `scripts-abnt/bin/cria_intro_cap.sh BASE lang cap_dir`

## 7. Critérios de aprovação
- Não existem seções proibidas no PDF.
- Todos capítulos selecionados têm `00_intro.md`.
- Compila sem `! LaTeX Error`.
- TOC presente; profundidade 2.
- Log sem “Missing character” repetitivo (hífens/NBSP tratados).
- `.md` em UTF-8.
