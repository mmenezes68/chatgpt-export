# 2. Objetivos

Este capítulo detalha os **objetivos principais** do projeto, divididos entre gerais e específicos, com foco na padronização de fluxos, automação e suporte bilíngue.

## 2.1 Objetivo Geral
Estabelecer um **ecossistema integrado** de produção, manutenção e publicação de conteúdos acadêmicos em Markdown, com geração automática de relatórios **ABNT** e integração nativa com **Obsidian** e **GitHub**, visando uso humano e automação via GPT Business.

## 2.2 Objetivos Específicos

1. **Padronizar** a estrutura e nomenclatura dos arquivos `.md`:
   - Compatível com Obsidian.
   - Respeitando hierarquia de capítulos.
   - Com suporte a versões bilíngues (PT/EN).

2. **Automatizar** a geração de relatórios acadêmicos:
   - Scripts em shell (bash/zsh).
   - Uso de **Pandoc** + **XeLaTeX** para compilar PDFs.
   - Inclusão de **capa** e **sumário automáticos**.

3. **Garantir conformidade ABNT mínima**:
   - Numeração de seções.
   - Estrutura de títulos/subtítulos coerente.
   - Respeito a margens, capa e sumário.

4. **Facilitar integração com ferramentas existentes**:
   - Obsidian como front-end de estudo.
   - GitHub como repositório de versionamento.
   - Suporte a colaboração entre múltiplos autores.

5. **Permitir evolução escalável**:
   - Projeto aplicável a uma obra isolada ou a múltiplas obras.
   - Scripts genéricos que funcionem em qualquer instância de obra.
   - Suporte futuro a citações, referências e glossários.

## 2.3 Benefícios Esperados
- **Clareza**: padrões consistentes em todos os documentos.
- **Eficiência**: redução do retrabalho por automação de normalização e *build*.
- **Escalabilidade**: suporte a múltiplas obras sem perda de padrão.
- **Colaboração**: versionamento em GitHub garante rastreabilidade.
- **Integração com IA**: GPT Business poderá ler o caderno e aplicar correções/novos *builds* com base em requisitos objetivos.

