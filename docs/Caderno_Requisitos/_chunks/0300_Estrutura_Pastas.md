# 3. Estrutura de Pastas do Projeto

A estrutura abaixo organiza obras (PT/EN), scripts e documentação para facilitar automação, navegação no Obsidian e builds reproduzíveis.projeto-obras/
├─ obras/
│   └─ Nome_da_Obra/
│       ├─ raw/                       # fontes originais (PDF, txt, notas soltas)
│       ├─ pt/
│       │   ├─ 00_front-matter/
│       │   │   └─ Resumo.md
│       │   ├─ 01_capitulos/
│       │   │   └─ Capítulo_01_Titulo/
│       │   │       ├─ 00_intro.md
│       │   │       ├─ 01_ideias_principais.md
│       │   │       ├─ 02_conceitos_chave.md
│       │   │       ├─ 03_questoes_reflexao.md
│       │   │       └─ 04_trechos_relevantes.md
│       │   └─ 99_back-matter/
│       └─ en/
│           ├─ 00_front-matter/
│           │   └─ Abstract.md
│           ├─ 01_chapters/
│           │   └─ Chapter_01_Title/
│           │       ├─ 00_intro.md
│           │       ├─ 01_main_ideas.md
│           │       ├─ 02_key_concepts.md
│           │       ├─ 03_reflection_questions.md
│           │       └─ 04_relevant_passages.md
│           └─ 99_back-matter/
├─ scripts-abnt/
│   ├─ bin/                           # *.sh (normalize, verify, build)
│   └─ templates/                     # abnt_header.tex, abnt_cover.tex
├─ docs/
│   └─ Caderno_Requisitos/
│       ├─ imagens/logo_govpro.jpeg
│       ├─ _chunks/                   # capítulos deste caderno (gerados)
│       └─ caderno_requisitos.md      # montado pelo assembler
└─ README.md**Notas**
- Nomes de pastas de capítulos devem manter o padrão `Capítulo_XX_Título` (PT) e `Chapter_XX_Title` (EN).
- Arquivos internos com prefixo numérico (`00_`, `01_`, `02_`...) para garantir ordem determinística.
- Conteúdos EN só devem ser publicados após *seed* (cópia do PT) e revisão humana.
