# ACCEPTANCE TESTS

## T1 — Verificação estática
- Rodar `scripts-abnt/bin/normalize_text.sh` nos `.md` do capítulo; não restar NBSP/hífens especiais/emoji.
- Verificar `00_intro.md` presente em cada capítulo.
- Grep para seções proibidas retorna vazio.
- Links wiki/markdown foram achatados pelo normalizador.

## T2 — Build PT
- `relatorio_full.sh` com um capítulo real:
  - Sem `! LaTeX Error`.
  - TOC na página 2, profundidade 2.
  - Sem “Missing character” repetitivo.

## T3 — Build EN (se houver conteúdo)
- `gera_relatorio_bilingue.sh` gera PT e EN ou avisa ausência de EN.

## T4 — Layout mínimo
- Capa sem numeração.
- Cabeçalhos numerados até nível 1.
- Fonte Times (ou fallback).

## T5 — Reprodutibilidade
- Em clone limpo, mesmos `.md` → mesmo PDF.

## T6 — CI futuro
- Workflow no GitHub Actions executa T1–T3 em PRs que mexem em `bin/` ou `templates/`.
