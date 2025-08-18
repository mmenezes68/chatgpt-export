<p align="center">
  <img src="imagens/logo_govpro.jpeg" alt="Logo GOVPRO" width="180"/>
</p>

# Caderno de Requisitos — Projeto Obras (ABNT + Obsidian)

**GOVPRO** — Provedora do projeto

**Versão:** 1.0  
**Última atualização:** <!-- atualize quando necessário -->

---

## Sumário

- [1. Visão Geral](#1-visão-geral)
- [2. Escopo e Objetivos](#2-escopo-e-objetivos)
- [3. Estrutura de Pastas do Projeto](#3-estrutura-de-pastas-do-projeto)
- [4. Organização dos Arquivos Markdown](#4-organização-dos-arquivos-markdown)
- [5. Scripts e Automação](#5-scripts-e-automação)
- [6. Integração com Obsidian e GitHub](#6-integração-com-obsidian-e-github)
- [7. Requisitos Específicos (ABNT, PT/EN)](#7-requisitos-específicos-abnt-pten)
- [8. Casos de Uso](#8-casos-de-uso)
- [9. Validação e Testes](#9-validação-e-testes)
- [10. Próximos Passos](#10-próximos-passos)

---


---

# 1. Visão Geral

Este caderno consolida **tudo que o GPT Business e humanos precisam** para evoluir o projeto:
- Como organizar obras em PT/EN para o **Obsidian**.
- Como gerar relatórios **ABNT** em PDF com **Pandoc + XeLaTeX**.
- Como padronizar os **.md** (estrutura, metadados, links, nomenclatura).
- Como automatizar (scripts) e validar (checklist/CI) o resultado.

## 1.1 Objetivos principais
- **Reprodutibilidade:** mesmo insumo → mesmo PDF.
- **Evolução contínua:** requisitos versionados no **GitHub** orientam correções por humanos e pelo **GPT Business**.
- **Bilíngue (PT/EN):** garantir consistência entre versões e *build* estável.
- **Compatibilidade com Obsidian:** leitura, navegação e backlinks sem quebras.

## 1.2 Escopo deste caderno
Inclui:
- Regras para estrutura de pastas por **obra** (PT/EN) e por **capítulo**;
- Padrões de conteúdo e nomenclatura dos `.md`;
- Scripts de normalização de texto e *build* (Pandoc/XeLaTeX);
- Geração **bilíngue** (quando houver conteúdo em EN);
- Verificações estáticas (linters/checks), *Makefile* e orientação ao CI.

Não inclui (neste estágio):
- Normas ABNT completas (citações, referências e sumário detalhado avançado);
- Gestão bibliográfica complexa. *(Planejado para versões futuras.)*

## 1.3 Público-alvo
- Autores e revisores de conteúdo;
- Mantenedores de scripts (devops/devs);
- **GPT Business**, como agente de automação (refactors e builds).

## 1.4 Premissas técnicas
- **macOS** (zsh/bash, `iconv`, `perl`) como ambiente-alvo primário.
- Todos os `.md` em **UTF-8**; caracteres problemáticos (NBSP, traços especiais, emojis) **normalizados**.
- **Pandoc** + **XeLaTeX** instalados localmente.
- Repositório hospedado no **GitHub** para versionamento e CI.

## 1.5 Entregáveis deste projeto
- Estrutura padrão por obra e capítulo (PT/EN).
- Scripts em `projeto-obras/scripts-abnt/bin`.
- Templates LaTeX mínimos (`abnt_header.tex`, `abnt_cover.tex`).
- **Caderno de Requisitos** (este documento) em `docs/Caderno_Requisitos/`.

## 1.6 Critérios de pronto (DoD)
- `.md` válidos (UTF-8, sem links não achatados nem seções proibidas).
- *Build* local gera PDF sem erros do LaTeX.
- Sumário presente; numeração de seções ativa.
- PT compila sempre; EN compila quando existir *seed* e revisão.
- CI (quando configurado) executa *checks* e *build* mínimo sem erro.

## 1.7 Linha do tempo e evolução
- Começo com layout ABNT **mínimo** (capa + sumário + numeração).
- Evolução para tipografia e normas ABNT mais completas (citações, referências, rodapés, etc.) mediante requisitos adicionais.
- Histórico semântico no Git: **feat / fix / docs** indicando impacto em linters e/ou build.


---

# 2. Escopo e Objetivos

Este capítulo define **escopo**, **objetivos**, **não-metas**, **riscos**, **dependências**, **personas**, requisitos funcionais e não-funcionais, além de **critérios de aceitação** e **governança**. Ele serve como contrato de entendimento entre humanos e o **GPT Business** para evoluções automáticas do projeto.

## 2.1 Escopo (o que está dentro)
- Ingestão de obras (PDF/texto) e organização em **PT/EN** por **capítulo**.
- Produção de arquivos `.md` compatíveis com **Obsidian** (estrutura e links).
- Geração de relatório PDF com **Pandoc + XeLaTeX**, com:
  - Capa automática (logo GOVPRO, título, autor/orientador, instituição, data)
  - Sumário
  - Numeração de seções (nível 1)
- Scripts de automação:
  - Normalização UTF-8 e limpeza de Unicode problemático
  - Montagem do relatório a partir de `.md` individuais
  - Geração bilíngue opcional quando houver conteúdo EN
- Regras de organização e nomenclatura dos `.md` por capítulo.
- Validação estática (linters/checks) e *make targets* locais.
- Base para CI em PRs (verificações/builder mínimo).

## 2.2 Objetivos (resultados esperados)
- **Reprodutibilidade**: mesmo insumo → mesmo PDF.
- **Padronização**: estrutura de pastas e arquivos previsível.
- **Manutenibilidade**: scripts claros, isolados e testáveis.
- **Escalabilidade editorial**: facilitar N obras e capítulos.
- **Automação assistida**: permitir que o GPT Business aplique correções com segurança.

## 2.3 Fora de escopo (não-metas, por enquanto)
- Normas ABNT completas (citações/referências complexas, rodapé, listas de ilustrações) — evolução futura.
- Extração automática de conteúdo de PDFs protegidos/escaneados.
- Tradução automática PT↔EN sem revisão humana.
- Gestão de bibliografia (BibTeX/Zotero) além do básico.

## 2.4 Premissas
- Ambiente principal: **macOS** (zsh/bash, `iconv`, `perl` disponíveis).
- **Pandoc** e distribuição TeX com **XeLaTeX** instalados localmente.
- Todos os `.md` em **UTF-8**.
- Conteúdo EN é opcional e compilado somente se existir.

## 2.5 Restrições
- Uso mínimo de LaTeX, focado apenas no que precisamos (capa, sumário, fonte, idioma).
- Sem dependências proprietárias fora do TeX/Pandoc.
- Pastas/arquivos devem seguir a convenção — scripts dependem disso.

## 2.6 Riscos e mitigação
- **R1**: Caractere Unicode “invisível” quebra build → *mitigar com normalização e mapeamentos unicode mínimos*.
- **R2**: Estrutura de pastas incorreta → *linters* (`verify_md.sh`) acusam e bloqueiam.
- **R3**: Falhas no XeLaTeX por template → templates mínimos + *logs* detalhados no erro.
- **R4**: Divergência PT/EN → *seed_en_from_pt.sh* para sincronizar rascunho e checklist de revisão.
- **R5**: Regressões por PR → Makefile e checks (e futuro CI) nos caminhos críticos (`bin/`, `templates/`).

## 2.7 Dependências
- **Soft**: `bash`/`zsh`, `iconv`, `perl`, `pandoc`, `xelatex`.
- **Diretórios padrão** (por obra):
  - PT: `pt/01_capitulos/Capítulo_XX_Título/`
  - EN: `en/01_chapters/Chapter_XX_Title/`
- **Templates**: `abnt_header.tex`, `abnt_cover.tex`.

## 2.8 Personas
- **Autor/Revisor**: escreve/revisa `.md` em PT/EN.
- **Dev/Scripter**: mantém scripts e pipelines.
- **Agente GPT Business**: lê este caderno e propõe/refatora scripts conforme regras.

## 2.9 Requisitos funcionais (FR)
- **FR-01**: Normalizar `.md` para UTF-8 e remover Unicode problemático.
- **FR-02**: Montar relatório PDF a partir de seções padronizadas do capítulo.
- **FR-03**: Gerar capa com variáveis (título, autor, orientador, instituição, cidade, data).
- **FR-04**: Incluir sumário e numeração de seções (nível 1).
- **FR-05**: *Build* PT sempre; EN quando houver conteúdo.
- **FR-06**: Sinalizar erros de LaTeX/Pandoc de forma legível e com `pandoc.log`.
- **FR-07**: Semear EN a partir de PT quando solicitado (arquivo EN recebe “TODO translate” + cópia do PT).
- **FR-08**: Verificar capítulo com *linter* (`verify_md.sh`):
  - proibir links não achatados/“wiki links”,
  - exigir `00_intro.md`,
  - acusar seções “Conexões/Metadados adicionais/Sugestões de linkagem/Insights”.

## 2.10 Requisitos não-funcionais (NFR)
- **NFR-01 (Reprodutibilidade)**: *Build* determinístico no macOS.
- **NFR-02 (Observabilidade)**: *logs* de build salvos em `/tmp/relatorio_*/pandoc.log`.
- **NFR-03 (Confiabilidade)**: scripts `set -euo pipefail`.
- **NFR-04 (Compatibilidade)**: Markdown compatível com Obsidian.
- **NFR-05 (Evolutividade)**: templates/shell simples de estender; requisitos versionados.

## 2.11 Critérios de aceitação (amostra)
| ID   | Critério                          | Como verificar                      | OK quando…                  |
|:----:|-----------------------------------|-------------------------------------|-----------------------------|
| CA-1 | UTF-8 em todos os `.md`           | `normalize_utf8.sh` + `verify_md.sh`| sem alertas de encoding     |
| CA-2 | Capa + Sumário no PDF             | `relatorio_full.sh`                 | PDF abre com capa e sumário |
| CA-3 | Sem Unicode problemático          | `verify_md.sh`                      | sem avisos NBSP/hífens/etc. |
| CA-4 | EN só se houver conteúdo          | `gera_relatorio_bilingue.sh`        | EN pula quando não houver   |
| CA-5 | Estrutura por obra/capítulo       | inspeção + *linter*                 | encontra `00_intro.md`      |

## 2.12 Governança
- **Provedora**: GOVPRO.
- **Workflow Git**: PRs com mensagens semânticas (`feat:`, `fix:`, `docs:`).
- **CI (futuro)**: verificação estática e *build* mínimo em PRs que alterem `bin/` e `templates/`.

# 3. Estrutura de Pastas do Projeto

Este capítulo define a **organização de diretórios e arquivos** do repositório `projeto-obras`. A padronização garante previsibilidade, facilita navegação no Obsidian, permite que os scripts operem corretamente e assegura versionamento claro no GitHub.

---

## 3.1 Estrutura de alto nível

projeto-obras/

├─ pt/            # Obras em Português

├─ en/            # Obras em Inglês (opcional)

├─ raw/           # Fontes originais (PDFs, textos brutos)

├─ scripts-abnt/       # Scripts e templates LaTeX/Pandoc

├─ docs/           # Documentos auxiliares (como este Caderno)

└─ README.md         # Visão geral do repositório

**Regras:**

- `pt/` e `en/` sempre coexistem (mesmo que `en/` esteja vazio).
- `raw/` contém insumos sem edição (PDFs, TXT, etc.).
- `scripts-abnt/` armazena templates LaTeX, Makefiles e scripts de build.
- `docs/` guarda este caderno e documentação técnica.

---

## 3.2 Estrutura dentro de cada obra

### Em Português (PT):

pt/01_capitulos/Capítulo_XX_Título/

├─ 00_intro.md

├─ 01_ideias_principais.md

├─ 02_conceitos_chave.md

├─ 03_questoes_reflexao.md

└─ 04_trechos_relevantes.md

### Em Inglês (EN):

en/01_chapters/Chapter_XX_Title/

├─ 00_intro.md

├─ 01_main_ideas.md

├─ 02_key_concepts.md

├─ 03_reflection_questions.md

└─ 04_relevant_passages.md

**Convenções:**

- Pastas `Capítulo_XX_Título/` e `Chapter_XX_Title/` usam prefixo numérico (`01_`, `02_`…) para ordenar.
- Os arquivos internos têm nomes fixos (`00_intro.md`, `01_…` etc.).
- Títulos de pastas com `_` (underscore), sem acentos sempre que possível.
- EN é opcional, mas quando existir deve refletir o mesmo conteúdo do PT.

---

## 3.3 Estrutura de `scripts-abnt/`

scripts-abnt/

├─ bin/

│ ├─ normalize_utf8.sh    # normaliza encoding UTF-8

│ ├─ verify_md.sh       # linter para .md

│ ├─ relatorio_full.sh    # build completo (PT e EN)

│ ├─ seed_en_from_pt.sh    # gera versão EN a partir do PT

│ └─ gera_relatorio_bilingue.sh

├─ templates/

│ ├─ abnt_header.tex

│ ├─ abnt_cover.tex

│ └─ Makefile

└─ README.md

**Funções:**

- `bin/` → scripts de automação (build, linter, sincronização PT/EN).
- `templates/` → LaTeX mínimo para ABNT (capa, sumário, fonte, idioma).
- `Makefile` → targets para build local e CI.

---

## 3.4 Estrutura de `docs/`

docs/

└─ Caderno_Requisitos/

├─ caderno_requisitos.md  # versão concatenada

├─ imagens/

│ └─ logo_govpro.jpeg

└─ _chunks/

├─ 0100_Capa_Sumario.md

├─ 0200_Visao_Geral.md

├─ 0300_Escopo_Objetivos.md

└─ 0400_Estrutura_Pastas.md

- `caderno_requisitos.md` = documento principal, compilado a partir de `_chunks`.
- `imagens/` = logos e figuras usadas no documento.
- `_chunks/` = capítulos individuais em `.md` (cada script gera um).

---

## 3.5 Estrutura de `raw/`

raw/

├─ obra1_original.pdf

├─ obra2_scan.pdf

└─ README.md

- Mantém os **insumos originais** inalterados.
- Apenas leitura; não sofrerão edição.
- Usados como referência ou material de backup.

---

## 3.6 Resumo das convenções

- **PT é referência**, EN é opcional.
- **Prefixos numéricos** garantem ordem previsível.
- **Arquivos fixos (00..04)** em cada capítulo.
- **Scripts e templates** ficam centralizados em `scripts-abnt/`.
- **Caderno** fica em `docs/…`.
- **Insumos brutos** ficam em `raw/`.

---

## 3.7 Critérios de aceitação (estrutura de pastas)

|  ID  | Critério                                                  | Como verificar          | OK quando…                       |
| :--: | --------------------------------------------------------- | ----------------------- | -------------------------------- |
|  E1  | Diretórios `pt/`, `en/`, `raw/`, `scripts-abnt/`, `docs/` | inspeção                | todos existem                    |
|  E2  | Cada capítulo PT tem 5 arquivos (00..04)                  | `verify_md.sh`          | check passa sem erro             |
|  E3  | EN (quando existir) reflete PT                            | inspeção + `seed_en…`   | pastas e arquivos espelhados     |
|  E4  | `scripts-abnt/` contém bin + templates                    | inspeção                | todos presentes e executáveis    |
|  E5  | `docs/Caderno_Requisitos/` contém chunks                  | inspeção + concatenação | `caderno_requisitos.md` é gerado |

---

## 3.8 Notas finais

A estrutura aqui definida é **contrato rígido**:  

- Scripts dependem dela para localizar arquivos.  
- Obsidian depende dela para navegação coerente.  
- CI (futuro) depende dela para validar PRs.  

Qualquer alteração deve ser discutida via PR e registrada neste **Caderno de Requisitos**.

# 4. Organização dos Arquivos Markdown



Este capítulo estabelece **regras, padrões e exemplos** para a produção de arquivos `.md` a fim de:

\- Garantir **compatibilidade** com Obsidian;

\- Evitar quebras no build **Pandoc + XeLaTeX**;

\- Facilitar a automação por scripts e pelo **GPT Business**;

\- Manter **consistência** entre PT/EN e entre diferentes obras.

## **4.2 Boas práticas**



- **UTF-8 sempre** (scripts normalizam, mas evite conteúdos com encoding estranho).
- Evitar NBSP/traços especiais (U+00A0, 2011, 2013, 2014) e emojis/VS16.
- Sem HTML desnecessário.
- Parágrafos curtos e objetivos.

## **4.3 YAML front-matter (opcional)**

---

title: "Capítulo 1 – Facing Up to the Problem of Consciousness"
language: "pt"

tags: ["consciência", "filosofia"]
---

Uso moderado; se causar conflito no build, remover.



## **4.4 Links e referências**

- **Proibido**: wiki-links crus do Obsidian: [[alvo|texto]], [[alvo]].

- **Permitido**: texto plano ou link Markdown padrão só quando necessário:

  

  - [[alvo|texto]] → **texto**
  - [texto](https://exemplo.com) → manter se for essencial

  Regra: se o link não for essencial no PDF, prefira **texto**.

  

## **4.5 Nomeação por capítulo**

**PT**

00_intro.md
01_ideias_principais.md
02_conceitos_chave.md
03_questoes_reflexao.md
04_trechos_relevantes.md

**EN**

00_intro.md
01_main_ideas.md
02_key_concepts.md
03_reflection_questions.md
04_relevant_passages.md

Regras:



- Prefixo numérico para ordenar.
- Sem espaços; usar _.



## **4.6 Seções proibidas (por ora)**

- “Conexões/Conexoes”, “Metadados adicionais”, “Sugestões de linkagem”, “Insights”.

## **4.7 Blocos de código**

Use:

\```bash

echo "Exemplo"

Evite trechos gigantes; se necessário, dividir.

## 4.8 Compatibilidade com Obsidian

Abrir, navegar e editar sem `[[...]]` crus nos arquivos que vão para o PDF.

## 4.9 Compatibilidade com Pandoc/XeLaTeX

- Um H1 por arquivo; subseções bem hierarquizadas.
- Sumário e numeração vêm do Pandoc.

## 4.10 Checklist por arquivo

- [ ] UTF-8; sem NBSP/traços especiais/emojis
- [ ] H1 único no topo
- [ ] Hierarquia `##`, `###` correta
- [ ] Sem wiki-links crus; links externos só se necessário
- [ ] Sem seções proibidas
- [ ] (Opcional) YAML simples e válido

## 4.11 Exemplos (PT)

**00_intro.md**

```markdown
# Introdução
Contexto e objetivos do capítulo.
```

**01_ideias_principais.md**

# Ideias Principais

1. Primeira ideia...
2. Segunda ideia...

**02_conceitos_chave.md**

# Conceitos-Chave

- Qualia
- Dualismo de propriedades

**03_questoes_reflexao.md**

# Questões para Reflexão

- Em que medida a experiência subjetiva é...

**04_trechos_relevantes.md**

# Trechos Relevantes

> “Citação…” (p. 15)

## **4.12 O que o linter verifica**

- 00_intro.md ausente;
- Links wiki/Markdown não achatados;
- Unicode problemático (NBSP/traços/VS16);
- Títulos fora do padrão.

## **4.13 Critérios de aceitação**

| **D** | **Critério**                       | **Verificação**  | **OK quando…**               |
| ----- | ---------------------------------- | ---------------- | ---------------------------- |
| M1    | H1 único por arquivo               | inspeção + build | numeração e sumário corretos |
| M2    | Sem wiki-links crus                | verify_md.sh     | linter não acusa             |
| M3    | Sem Unicode problemático           | verify_md.sh     | linter não acusa             |
| M4    | Nomes por capítulo conforme padrão | inspeção + build | 5 partes incluídas           |
| M5    | YAML (se usado) simples e válido   | inspeção         | sem erros no Pandoc          |

## **4.14 Observações finais**

Este capítulo é **normativo**. Mudanças exigem PR e atualização deste caderno.

MD

# **============== CONCATENAR (cumulativo) ================**

mkdir -p “$CR_DIR”

# **Use nullglob p/ evitar passar literal “0\*.md” vazio**

shopt -s nullglob

mapfile -t chunks < <(ls -1 “$CH_DIR”/0*.md 2>/dev/null | sort)

if (( ${#chunks[@]} == 0 )); then

echo “ERRO: nenhum chunk 0*.md encontrado em $CH_DIR” >&2

exit 1

fi

{

for f in “${chunks[@]}”; do

cat “$f”

printf “\n\n—\n\n”

done

} > “$OUT_MD”



echo “✅ Caderno atualizado (inclui Cap. 4):”

echo “  $OUT_MD”

echo “📄 Ordem dos chunks concatenados:”

printf ’ - %s\n’ “${chunks[@]}”

# 5. Scripts e Automação

Este capítulo descreve os **scripts**, **templates** e **alvos de build** que compõem o pipeline do projeto, além de **variáveis**, **logs**, **exemplos de uso** e **boas práticas** para que humanos e o **GPT Business** possam operar e evoluir o sistema com segurança.

## 5.1 Visão geral do pipeline

Fluxo típico (PT):

1. **Organização da obra** (pastas e arquivos `.md` por capítulo).
2. **Normalização** de texto (UTF-8 e limpeza de Unicode problemático).
3. **Verificação estática** (linter) dos `.md` do capítulo.
4. **Montagem do PDF** via Pandoc + XeLaTeX (capa, sumário, numeração).
5. (Opcional) **Geração bilíngue** (EN) se houver conteúdo.
6. **Logs** e *artifacts* armazenados; reprodutibilidade garantida.

---

## 5.2 Scripts principais (pasta `scripts-abnt/bin`)

- **`normalize_utf8.sh`**  
  Normaliza todos os `.md` para **UTF-8**, substitui NBSP/traços especiais, remove VS16 (emoji selector) e emite a lista de arquivos processados.  

  **Uso:**

  ```bash
  scripts-abnt/bin/normalize_utf8.sh caminho/da/obra
  ```

- **`verify_md.sh`**  
  Linter do capítulo (PT/EN). Falha se:

  - faltar `00_intro.md`;
  - houver wiki-links/links markdown aplaináveis (`[[...]]` ou `[texto](url)` onde o texto deveria ser puro);
  - houver NBSP/hífens especiais/VS16.  

  **Uso:**

  ```bash
  scripts-abnt/bin/verify_md.sh caminho/da/obra pt "Capítulo_XX_Título"
  scripts-abnt/bin/verify_md.sh caminho/da/obra en "Chapter_XX_Title"
  ```

- **`relatorio_full.sh`**  
  Monta um **PDF** do capítulo **PT ou EN** com:

  - **capa** (variáveis: Título/Autor/Orientador/Instituição/Cidade/Data);
  - **sumário** (TOC, profundidade 2);
  - **numeração** de seções (nível 1).  

  Usa os templates: `templates/abnt_header.tex` e `templates/abnt_cover.tex`.  

  **Parâmetros obrigatórios:**  
  `--obra`, `--capitulos`, `--title`, `--author`, `--advisor`, `--out`.  

  **Uso (PT):**

  ```bash
  scripts-abnt/bin/relatorio_full.sh     --obra "obras/The_Character_of_Consciousness"     --capitulos "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"     --title "Relatório de Leitura — TCoC (Cap. 1)"     --author "Seu Nome"     --advisor "Orientador"     --out "$HOME/Relatorio_PT.pdf"
  ```

  **Uso (EN):** definir antes:

  ```bash
  export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
  ```

- **`gera_relatorio_bilingue.sh`**  
  Executa o fluxo **PT** e, se detectar `en/` com `.md` até 3 níveis, executa **EN** também.  

  **Uso:**

  ```bash
  scripts-abnt/bin/gera_relatorio_bilingue.sh     --obra "obras/The_Character_of_Consciousness"     --capitulos "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"     --author "Seu Nome"     --advisor "Orientador"
  ```

- **`cria_obra.sh`**  
  Cria o **esqueleto** de uma obra com pastas PT/EN/RAW.  

  ```bash
  scripts-abnt/bin/cria_obra.sh "The_Character_of_Consciousness"
  ```

- **`cria_intro_cap.sh`**  
  Cria a pasta do **capítulo** e um `00_intro.md` inicial (PT ou EN).  

  ```bash
  scripts-abnt/bin/cria_intro_cap.sh     "obras/The_Character_of_Consciousness"     pt "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"
  ```

- **`seed_en_from_pt.sh`** *(opcional/futuro)*  
  Copia `.md` PT → EN com marcações “TODO translate” para revisão humana.

---

## 5.3 Templates LaTeX (pasta `scripts-abnt/templates`)

- **`abnt_header.tex`**  

  - Fonte: Times New Roman (via `fontspec`);
  - Idioma principal: `polyglossia` (`portuguese`, `english` como secundária);
  - `hyperref` com links ocultos;
  - Mapeamentos Unicode mínimos (traços especiais → `-`).  

  Objetivo: **robustez** e **mínimo necessário** para compilar.

- **`abnt_cover.tex`**  
  Capa “à prova de chaves” (sem braces em variáveis LaTeX).  
  Os campos são injetados pelo shell antes do Pandoc.

---

## 5.4 Makefile (alvos típicos)

**Variáveis padrão** que você pode sobrepor na execução:  
`PT_OBRA` (dir da obra), `PT_CAP` (nome do capítulo).  

**Exemplos:**

```bash
make check      PT_OBRA="obras/The_Character" PT_CAP="Capítulo_01_..."
make build-pt   PT_OBRA="obras/The_Character" PT_CAP="Capítulo_01_..."
make build-en   PT_OBRA="obras/The_Character" PT_CAP="Capítulo_01_..."
make build-both PT_OBRA="obras/The_Character" PT_CAP="Capítulo_01_..."
```

---

## 5.5 Variáveis e ambiente

- **Locale**: para EN, use `LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8`.
- **XeLaTeX**: exige distribuição TeX instalada (macOS).
- **Pandoc**: necessário para conversão `.md` → `.pdf`.

---

## 5.6 Logs e diagnósticos

- Cada build cria um diretório temporário: `/tmp/relatorio_*`.
- **Log do Pandoc**: `/tmp/relatorio_*/pandoc.log`.
- Em erro, o script imprime o trecho relevante do log.

---

## 5.7 Exemplos de uso (do zero)

1. Criar obra e um capítulo:

   ```bash
   BIN=scripts-abnt/bin
   $BIN/cria_obra.sh "The_Character_of_Consciousness"
   BASE="obras/The_Character_of_Consciousness"
   $BIN/cria_intro_cap.sh "$BASE" pt "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"
   ```

2. Normalizar e verificar:

   ```bash
   $BIN/normalize_utf8.sh "$BASE"
   $BIN/verify_md.sh     "$BASE" pt "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"
   ```

3. Construir PDF PT:

   ```bash
   $BIN/relatorio_full.sh      --obra "$BASE"      --capitulos "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"      --title "Relatório de Leitura — TCoC (Cap. 1)"      --author "Seu Nome"      --advisor "Orientador"      --out "$HOME/Relatorio_PT.pdf"
   ```

   # 6. Integração com Obsidian e GitHub

   Este capítulo descreve como o projeto integra-se com **Obsidian** (para
   edição e navegação local) e com **GitHub** (para versionamento,
   colaboração e automações de CI/CD).

   ------------------------------------------------------------------------

   ## 6.1 Integração com Obsidian

   -   **Compatibilidade total**: todos os arquivos `.md` seguem sintaxe
       Markdown simples, sem uso de extensões exclusivas.\
   -   **Backlinks funcionais**: nomes de arquivos seguem convenções
       previsíveis (`00_intro.md`, `01_main_ideas.md`, etc.).\
   -   **Pastas por obra**:
       -   PT: `obras/<obra>/pt/01_capitulos/Capítulo_XX_Título/`\
       -   EN: `obras/<obra>/en/01_chapters/Chapter_XX_Title/`\
   -   **Visualização estruturada**: o sumário e a numeração de seções já
       se alinham ao grafo de navegação do Obsidian.\
   -   **Metadados YAML opcionais** podem ser usados para facilitar buscas
       (ex.: `tags:`, `author:`, `language:`).

   ------------------------------------------------------------------------

   ## 6.2 Integração com GitHub

   -   **Controle de versão**: todo o repositório é versionado no GitHub.\
   -   **Pull Requests (PRs)**:
       -   exigem mensagens semânticas: `feat:`, `fix:`, `docs:`.\
       -   devem indicar impacto em `bin/` ou `templates/` quando houver.\
   -   **Branches**:
       -   `main`: estável, sempre compilável.\
       -   `dev`: experimental, pode conter scripts em teste.\
   -   **Issues**: usadas para rastrear melhorias e bugs nos scripts ou
       requisitos.\
   -   **Releases**: podem gerar snapshots com PDFs estáticos.

   ------------------------------------------------------------------------

   ## 6.3 CI/CD (futuro)

   -   **Checks automáticos** ao abrir PRs:
       -   rodar `normalize_utf8.sh` e `verify_md.sh` para garantir
           consistência.\
       -   compilar um PDF de amostra com `relatorio_full.sh`.\
   -   **Artifacts de build**: armazenados como resultado do CI.\
   -   **Workflows YAML**: definidos em `.github/workflows/build.yml`.

   ------------------------------------------------------------------------

   ## 6.4 Benefícios da integração

   -   **Obsidian**: navegação rica, backlinks, uso em dispositivos
       locais.\
   -   **GitHub**: colaboração distribuída, histórico completo e CI.\
   -   **GPT Business**: pode ler diretamente este caderno e aplicar
       refactors de forma controlada.

   ------------------------------------------------------------------------

# 7. Requisitos Específicos (ABNT, PT/EN)

Este capítulo detalha os **requisitos normativos e técnicos específicos** que devem ser atendidos, considerando a conformidade com as normas **ABNT** e a manutenção de consistência entre as versões **PT** e **EN**.

## 7.1 Requisitos ABNT Mínimos

- **Capa obrigatória** contendo título, autor, orientador, instituição, cidade e data.
- **Sumário automático** até pelo menos o nível 2 de seções.
- **Numeração progressiva de seções** iniciando no nível 1.
- **Fonte padrão Times New Roman, corpo 12**, espaçamento 1,5 (configurado no LaTeX).
- **Margens padrão**: 3 cm (esquerda e superior), 2 cm (direita e inferior).
- **Paginação**: numerada a partir da introdução, canto superior direito.

## 7.2 Estrutura mínima de capítulo

Cada capítulo (PT ou EN) deve conter pelo menos:

1. **00_intro.md** – contextualização inicial.
2. **01_main_ideas.md** – ideias principais.
3. **02_key_concepts.md** – conceitos centrais.
4. **03_reflection_questions.md** – perguntas de reflexão.
5. **04_relevant_passages.md** – trechos importantes.

## 7.3 Bilíngue (PT/EN)

- Todo capítulo em **PT** pode ter seu correspondente em **EN**.
- Traduções podem ser semeadas automaticamente (`seed_en_from_pt.sh`).
- Revisão humana obrigatória antes de publicação.
- Geração de relatório bilíngue (`gera_relatorio_bilingue.sh`) só compila EN se houver conteúdo válido.

## 7.4 Compatibilidade com Obsidian

- Links internos sempre relativos, evitando caminhos absolutos.
- Não usar *wikilinks* (`[[...]]`), apenas `[texto](arquivo.md)`.
- Backlinks e grafos do Obsidian devem refletir corretamente a estrutura.

## 7.5 Normas adicionais

- **Citações diretas** curtas: até 3 linhas no corpo do texto.
- **Citações longas**: bloco destacado com recuo de 4 cm, fonte 10, espaçamento simples.
- **Notas de rodapé**: numeração automática, texto reduzido, no rodapé da página.
- **Referências**: padrão ABNT NBR 6023 (em evolução futura).

## 7.6 Critérios de Conformidade

- PDF gerado deve conter capa, sumário e numeração de seções.
- Fonte e margens conferidas pelo template LaTeX.
- Arquivos `.md` não devem conter caracteres invisíveis ou ligações inválidas.
- EN só é compilado quando houver conteúdo sincronizado.

---

# 8. Casos de Uso

Este capítulo descreve **cenários práticos** para aplicação do sistema em obras únicas e múltiplas, garantindo que humanos e o **GPT Business** compreendam como estruturar, compilar e manter diferentes contextos editoriais.

## 8.1 Caso de Uso: Obra Única

**Descrição**: Produção de relatório acadêmico baseado em uma obra central.

**Fluxo típico**:

1. Criar a obra com `cria_obra.sh`.
2. Criar capítulos sequenciais com `cria_intro_cap.sh`.
3. Produzir conteúdo em PT, opcionalmente EN.
4. Normalizar (`normalize_utf8.sh`) e verificar (`verify_md.sh`).
5. Compilar PDF único com `relatorio_full.sh`.

**Critérios de sucesso**:

- PDF final possui capa, sumário e capítulos completos.
- Estrutura compatível com Obsidian.
- Reprodutibilidade confirmada em mais de um ambiente.

---

## 8.2 Caso de Uso: Múltiplas Obras

**Descrição**: Gestão simultânea de várias obras vinculadas, compartilhando padrões de requisitos.

**Fluxo típico**:

1. Criar cada obra em `obras/` (PT/EN).
2. Seguir convenções de pastas e capítulos.
3. Integrar todas no Obsidian Vault.
4. Versionar no GitHub, garantindo consistência entre obras.
5. Usar Makefile para builds independentes ou globais.

**Critérios de sucesso**:

- Cada obra pode ser compilada separadamente.
- O vault do Obsidian permite navegação cruzada.
- O CI valida todas as obras de forma independente.

---

## 8.3 Caso de Uso: Evolução Colaborativa

**Descrição**: Múltiplos autores e o GPT Business colaboram no mesmo repositório.

**Fluxo típico**:

1. Autores submetem PRs com novos capítulos ou correções.
2. O GPT Business executa linters, normalização e sugere melhorias.
3. Revisores humanos aprovam.
4. CI executa *builds* de amostra em cada PR.

**Critérios de sucesso**:

- Nenhum PR entra no `main` sem build válido.
- Conflitos de merge resolvidos com apoio do GPT Business.
- Histórico semântico (feat/fix/docs) mantido.

---

## 8.4 Caso de Uso: Publicação Bilingue

**Descrição**: A mesma obra é publicada em PT e EN, com consistência garantida.

**Fluxo típico**:

1. Criar obra em PT.
2. Executar `seed_en_from_pt.sh` para gerar esqueleto em EN.
3. Traduzir manualmente ou com auxílio GPT.
4. Compilar com `gera_relatorio_bilingue.sh`.

**Critérios de sucesso**:

- PDFs PT e EN consistentes.
- Checklist confirma que todos os capítulos existem em ambas as línguas.
- Revisão humana garante fidelidade semântica.

---

## 8.5 Caso de Uso: Extensões Futuras

- **Gestão de referências (Zotero/BibTeX)**.
- **Exportação para EPUB/HTML** via Pandoc.
- **Integração com plataformas de submissão acadêmica**.
- **Automação de traduções assistidas**.

---

📌 Este capítulo serve como **guia prático** para validar o sistema em cenários reais, garantindo escalabilidade, colaboração e evolução contínua.

# 9. Validação e Testes

Este capítulo define **o que validar**, **como validar** e **quando** considerar um build/alteração como **aprovado**. O objetivo é garantir reprodutibilidade, robustez e previsibilidade para humanos e para o **GPT Business** que fará ajustes automáticos nos scripts.

---

## 9.1 Objetivo da validação

- **Detectar cedo** problemas de codificação (UTF-8), estrutura, links e caracteres invisíveis.
- **Garantir build estável** em **PDF** (Pandoc + XeLaTeX) com capa, sumário e numeração.
- **Padronizar** o que é “ok para merge” em PRs (local e CI).
- **Evitar regressões** via *checks* e comparações com saídas esperadas (quando aplicável).

---

## 9.2 Tipos de verificação

### 9.2.1 Verificação estática (linter)

Ferramenta: `scripts-abnt/bin/verify_md.sh`

Valida, por capítulo (PT/EN):

- Presença de `00_intro.md`.
- **Proíbe**: wiki-links `[[]]` e links Markdown vivos `[texto](url)` onde o texto precisa ser puro no relatório.
- **Rejeita**: Unicode problemático (NBSP U+00A0, hífens especiais U+2011/2013/2014, VS16 U+FE0F).

**Exemplo (PT):**

```bash
BIN=scripts-abnt/bin
BASE="projeto-obras/obras/The_Character_of_Consciousness"
CAP="Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"

$BIN/verify_md.sh "$BASE" pt "$CAP"
```

### 9.2.2 Normalização de texto (pré-check)

Ferramenta: `scripts-abnt/bin/normalize_utf8.sh`

- Converte todos os `.md` para UTF-8.
- Remove/normaliza NBSP, hífens especiais e seletor de variação (emoji).

**Exemplo:**

```bash
BIN=scripts-abnt/bin
BASE="projeto-obras/obras/The_Character_of_Consciousness"

$BIN/normalize_utf8.sh "$BASE"
```

### 9.2.3 Testes de build (PT/EN)

Ferramentas: `scripts-abnt/bin/relatorio_full.sh` e `scripts-abnt/bin/gera_relatorio_bilingue.sh`

- **PT**: sempre deve compilar se o capítulo estiver completo.
- **EN**: compila **apenas se** houver conteúdo `en/` detectado.

**Exemplo (PT):**

```bash
BIN=scripts-abnt/bin
BASE="projeto-obras/obras/The_Character_of_Consciousness"
CAP="Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"

$BIN/relatorio_full.sh   --obra "$BASE"   --capitulos "$CAP"   --title "Relatório de Leitura — TCoC (Cap. 1)"   --author "Seu Nome"   --advisor "Orientador"   --out "$HOME/Relatorio_PT_TESTE.pdf"
```

**Exemplo (bilingue):**

```bash
BIN=scripts-abnt/bin
BASE="projeto-obras/obras/The_Character_of_Consciousness"
CAP="Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"

$BIN/gera_relatorio_bilingue.sh   --obra "$BASE"   --capitulos "$CAP"   --author "Seu Nome"   --advisor "Orientador"
```

> **Observação:** `gera_relatorio_bilingue.sh` detecta conteúdo `en/` em até 3 níveis e só gera EN se encontrar `.md` válidos.

---

## 9.3 Build local via Makefile (atalhos)

Alvos usuais (permitem sobrescrever `PT_OBRA` e `PT_CAP`):

```bash
make check      PT_OBRA="projeto-obras/obras/The_Character..." PT_CAP="Capítulo_01_..."
make build-pt   PT_OBRA="projeto-obras/obras/The_Character..." PT_CAP="Capítulo_01_..."
make build-en   PT_OBRA="projeto-obras/obras/The_Character..." PT_CAP="Capítulo_01_..."
make build-both PT_OBRA="projeto-obras/obras/The_Character..." PT_CAP="Capítulo_01_..."
```

---

## 9.4 Critérios objetivos de aprovação (Definition of Done)

|  ID  | Critério                                     | Como verificar                       | OK quando…                                  |
| :--: | -------------------------------------------- | ------------------------------------ | ------------------------------------------- |
|  D1  | Todos os `.md` em UTF-8                      | `normalize_utf8.sh` + `verify_md.sh` | Sem alertas de encoding                     |
|  D2  | Links aplainados (sem wiki-links/URLs vivas) | `verify_md.sh`                       | Sem ocorrências                             |
|  D3  | Seções proibidas ausentes                    | `verify_md.sh`                       | Sem “Conexões/Metadados/Sugestões/Insights” |
|  D4  | `00_intro.md` presente                       | `verify_md.sh`                       | Encontrado                                  |
|  D5  | PDF PT gera sem erro                         | `relatorio_full.sh`                  | Sem `! LaTeX Error`                         |
|  D6  | TOC + numeração (nível 1)                    | PDF gerado                           | Visíveis no documento                       |
|  D7  | EN só quando houver conteúdo                 | `gera_relatorio_bilingue.sh`         | EN “pulado” quando não houver `en/`         |
|  D8  | Logs claros                                  | `/tmp/relatorio_*/pandoc.log`        | Erros/impressões diagnósticas legíveis      |

---

## 9.5 Testes de regressão (golden files) — opcional

Quando estabilizar layout/conteúdo de teste, podemos manter **artefatos de referência** (PDFs gerados a partir de um capítulo “exemplo”). Em cada mudança de template/script:

1. Rodar build e salvar PDF em `tests/golden/`.
2. Comparar metadados/tamanho e, se possível, dif de texto extraído (com `pdftotext`) para tolerar pequenas variações tipográficas.

**Exemplo (pseudo):**

```bash
# gerar novo PDF de teste
make build-pt PT_OBRA="..." PT_CAP="..."

# comparar com golden (metadados/tamanho)
cmp -s "out/Relatorio_PT_TESTE.pdf" "tests/golden/Relatorio_PT_TESTE.pdf" || echo "Diferença detectada"
```

---

## 9.6 Exemplos de execução ponta-a-ponta

```bash
# 1) Criar obra + capítulo
BIN=scripts-abnt/bin
$BIN/cria_obra.sh "The_Character_of_Consciousness"
BASE="projeto-obras/obras/The_Character_of_Consciousness"
$BIN/cria_intro_cap.sh "$BASE" pt "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"

# 2) Normalizar + verificar
$BIN/normalize_utf8.sh "$BASE"
$BIN/verify_md.sh     "$BASE" pt "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"

# 3) Build PT
$BIN/relatorio_full.sh   --obra "$BASE"   --capitulos "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"   --title "Relatório de Leitura — TCoC (Cap. 1)"   --author "Seu Nome"   --advisor "Orientador"   --out "$HOME/Relatorio_PT_TESTE.pdf"

# 4) Build bilíngue (se houver EN)
$BIN/gera_relatorio_bilingue.sh   --obra "$BASE"   --capitulos "Capítulo_01_Facing_Up_to_the_Problem_of_Consciousness"   --author "Seu Nome"   --advisor "Orientador"
```

---

## 9.7 Troubleshooting (erros comuns)

### 9.7.1 “Unknown option --obra.” (Pandoc)

Causa: scripts chamando `pandoc` diretamente sem filtrar opções.  
Ação: use `relatorio_full.sh` (ele prepara os `.md`, templates e só então invoca o `pandoc` correto).

### 9.7.2 “Package newunicodechar Error: ASCII character requested.”

Causa: mapeamentos inadequados no template LaTeX.  
Ação: use `abnt_header.tex` com **apenas** mapeamentos de traços **não ASCII** (– —) → `-`. Remova tentativa de mapear o `-` ASCII.

### 9.7.3 “Extra }, or forgotten \endgroup.”

Causa: variáveis de capa com chaves `{}` literais ou barras invertidas.  
Ação: capa deve ser gerada por *preprocess* (envsubst/sed seguro). Use o `abnt_cover.tex` fornecido.

### 9.7.4 “! LaTeX Error” genérico

Ação:

1) Abrir o log: `/tmp/relatorio_*/pandoc.log`  
2) Conferir linha exata do erro.  
3) Ajustar `.md` suspeito (caracteres invisíveis, bloco mal fechado).  
4) Re-rodar normalização e build.

### 9.7.5 “Diretório de capítulos não encontrado”

Causa: variável `PT_CAP`/`PT_OBRA` errada ou estrutura diferente.  
Ação: conferir `cria_obra.sh` e `cria_intro_cap.sh` para a estrutura esperada.

---

## 9.8 Métricas e observabilidade

- **Taxa de falhas de build** por PR.
- **Tempo médio de build** local/CI.
- **Ocorrências** por tipo de erro (encoding, LaTeX, estrutura).  
- **Cobertura de verificação** (quantos capítulos passam no linter).

> Dica: registrar métricas simples em artefatos do CI (logs agregados).

---

## 9.9 Checklist final por PR

- [ ] `normalize_utf8.sh` rodado na obra alterada.
- [ ] `verify_md.sh` em todos os capítulos tocados.
- [ ] Build PT **ok** (`relatorio_full.sh`).
- [ ] EN apenas se houver conteúdo (`gera_relatorio_bilingue.sh`).
- [ ] Sem seções proibidas/links vivos em `.md`.
- [ ] Mensagem de commit semântica (`feat:`, `fix:`, `docs:`).

---

## 9.10 Plano de evolução da qualidade

- Adicionar **GitHub Actions** para executar *check + build* em PRs que toquem `scripts-abnt/bin/` e `scripts-abnt/templates/`.

- Introduzir **golden files** (PDF/texto) para regressão controlada.

- Expandir linters para verificar **metadados YAML** quando começarmos a usá-los.

- Incluir **testes end-to-end** com amostra de capítulo PT/EN no repositório de *fixtures*.

  

# 10. Próximos Passos

Este capítulo apresenta as próximas etapas para consolidação e evolução do projeto, garantindo que o caderno de requisitos seja aplicado de forma prática e sustentável.

## 10.1 Organização do Repositório

- Consolidar todos os capítulos no arquivo `caderno_requisitos.md`.
- Manter os arquivos originais em `_chunks/` para rastreabilidade.
- Garantir que cada alteração seja acompanhada por commit descritivo no Git.

## 10.2 Automação e CI/CD

- Implementar **GitHub Actions** para validar os `.md` e gerar PDFs automaticamente a cada *push* ou *pull request*.
- Incluir testes básicos: normalização UTF-8, verificação de links e *build* Pandoc.
- Publicar os PDFs como *artifacts* de CI.

## 10.3 Expansão de Funcionalidades

- Evoluir templates ABNT para suportar citações, referências e rodapés.
- Implementar suporte opcional a gestão bibliográfica (ex.: BibTeX, Zotero).
- Adicionar funcionalidades de tradução assistida para PT ↔ EN.

## 10.4 Documentação e Treinamento

- Criar guia rápido para autores e revisores.
- Elaborar documentação de scripts (uso, parâmetros e exemplos).
- Promover workshops internos para uso da pipeline com Obsidian + GitHub.

## 10.5 Governança e Sustentabilidade

- Definir responsáveis por manter os scripts e templates.
- Estabelecer ciclos de revisão trimestral do caderno de requisitos.
- Documentar decisões de evolução no repositório (`CHANGELOG.md`).

## 10.6 Próximas Entregas

- [ ] Publicação oficial do caderno no repositório GitHub.
- [ ] Configuração inicial do CI para build automático de PDFs.
- [ ] Teste de geração bilíngue em um caso real (obra piloto).
- [ ] Feedback de revisores sobre clareza e aplicabilidade.

---

**Conclusão:**  
O projeto estabelece uma base sólida para automação, padronização e versionamento de conteúdos acadêmicos. Os próximos passos garantem que esta estrutura evolua de forma escalável, confiável e alinhada às práticas da GOVPRO.
