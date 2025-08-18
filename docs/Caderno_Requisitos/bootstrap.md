# 🚀 Bootstrap --- Projeto Obras (GPT Business)

Este documento orienta o **GPT Business** a iniciar seu trabalho neste
repositório.\
Ele funciona como um *manual de ativação*, definindo o escopo, regras de
execução e prioridades de leitura.

------------------------------------------------------------------------

## 📂 Diretório do Projeto

-   **Local (macOS):** `~/chatgpt-export`\
-   **Remoto (GitHub):**
    [mmenezes68/chatgpt-export](https://github.com/mmenezes68/chatgpt-export)

Estrutura principal:

    chatgpt-export/
    ├─ docs/
    │  └─ Caderno_Requisitos/
    │     ├─ caderno_requisitos.md
    │     ├─ imagens/logo_govpro.jpeg
    │     └─ _chunks/ (opcional, partes geradas por script)
    ├─ scripts-abnt/
    │  ├─ bin/        # Scripts bash de build, verificação e automação
    │  └─ templates/  # Arquivos LaTeX mínimos (abnt_header.tex, abnt_cover.tex)
    └─ obras/
       └─ ...         # Obras organizadas em PT/EN

------------------------------------------------------------------------

## ⚙️ Estilo e Preferências

-   **Shell padrão:** `bash` (não usar `zsh`).\
-   **Criação de arquivos:** usar `cat <<'EOF' > arquivo` (não `nano`,
    não `echo`).\
-   **Scripts:** sempre iniciam com `#!/usr/bin/env bash` e
    `set -euo pipefail`.\
-   **Execução:** fornecer ao final do script exemplos prontos de
    `chmod +x` e `bash script.sh`.\
-   **Preferência do usuário:** sempre gerar scripts usando `cat` para
    maior clareza e reprodutibilidade.

------------------------------------------------------------------------

## 📘 Documentação Base

-   O **documento central** é:\
    `docs/Caderno_Requisitos/caderno_requisitos.md`

Ele contém regras sobre:

-   Estrutura de pastas e arquivos (`# 3`).\
-   Automação e scripts (`# 5`).\
-   Integração com Obsidian e GitHub (`# 6`).\
-   Requisitos específicos ABNT (`# 7`).

O GPT Business deve sempre **consultar esse documento antes de agir**.

------------------------------------------------------------------------

## 🎯 Escopo do GPT Business

-   **Sim**: refatorar, corrigir e gerar scripts/documentos conforme
    regras.\
-   **Não**: criar conteúdo fora das regras definidas no
    `caderno_requisitos.md`.

Prioridade de decisão:

1.  Regras do `caderno_requisitos.md`.\
2.  Estrutura real do repositório (`~/chatgpt-export`).\
3.  Preferências do usuário (ex.: uso de `cat`).

------------------------------------------------------------------------

## ✅ Critérios de Pronto (DoD)

-   Arquivos `.md` em UTF-8, sem wiki-links nem caracteres invisíveis.\
-   `normalize_utf8.sh` e `verify_md.sh` executam sem alertas.\
-   PDF gerado via `relatorio_full.sh` abre com capa e sumário.\
-   PT compila sempre; EN compila quando houver conteúdo válido.\
-   Commits no GitHub seguem convenção semântica: `feat/`, `fix/`,
    `docs/`.

------------------------------------------------------------------------

## 🔑 Fluxo Git/GitHub

-   Branch principal: `main`.\
-   Branches de trabalho: `feat/...`, `fix/...`, `docs/...`.\
-   Todo PR que altera `bin/` ou `templates/` deve conter build mínimo
    validado.\
-   Revisão deve incluir **PDF de teste** como artifact.

------------------------------------------------------------------------

## 📂 Localização de arquivos e caminhos reais

O GPT Business deve sempre respeitar a raiz do repositório:

-   **Scripts executáveis:** `scripts-abnt/bin/`\
-   **Templates LaTeX:** `scripts-abnt/templates/`\
-   **Caderno de requisitos:**
    `docs/Caderno_Requisitos/caderno_requisitos.md`\
-   **Imagens do caderno:** `docs/Caderno_Requisitos/imagens/`\
-   **Obras e capítulos:** `obras/<Nome_Da_Obra>/pt/...` e
    `obras/<Nome_Da_Obra>/en/...`

### 📌 Exemplos de criação com `cat`

Criar um novo script:

``` bash
cat <<'BASH' > scripts-abnt/bin/normalize_utf8.sh
#!/usr/bin/env bash
set -euo pipefail

echo "Normalizando UTF-8..."
# (lógica aqui)
BASH

chmod +x scripts-abnt/bin/normalize_utf8.sh
bash scripts-abnt/bin/normalize_utf8.sh
```

Criar um novo capítulo em PT:

``` bash
cat <<'MD' > obras/The_Character_of_Consciousness/pt/01_capitulos/Capítulo_02_Titulo/00_intro.md
# Introdução — Capítulo 2
Texto inicial do capítulo.
MD
```

------------------------------------------------------------------------

👉 **Resumo:**\
O GPT Business deve se **ancorar no `caderno_requisitos.md`** e neste
`bootstrap.md`.\
Todos os caminhos são **relativos à raiz `~/chatgpt-export`**, e scripts
devem ser gerados com `cat`, autoexecutáveis e com exemplo de uso.
