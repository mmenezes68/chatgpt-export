# USAGE — como rodar local e no CI

## Local (macOS)
1. Instale `pandoc` e um TeX distro com XeLaTeX.
2. Ajuste `PT_OBRA` e `PT_CAP` no `Makefile` se quiser.
3. Rode:
   - `make check` — valida capítulo PT.
   - `make build-pt` — gera PDF PT.
   - `make build-en` — gera PDF EN (se houver conteúdo).
   - `make build-both` — tenta gerar PT+EN (pula EN se faltar).

## CI (GitHub Actions)
- O workflow `.github/workflows/abnt-ci.yml` roda em cada push/PR.
- Para build real no CI, defina variáveis de ambiente do job:
  - `PT_OBRA_DIR` — diretório da obra usado no teste.
  - `PT_CAP_DIR` — nome do capítulo (ex.: `Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness`).

## Padrões de pastas e conteúdo
Veja `REQUIREMENTS.md` para a estrutura e regras aceitas (proibições, normalização, etc.).
