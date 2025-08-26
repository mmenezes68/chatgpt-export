#!/bin/bash
set -euo pipefail

REPO="$HOME/chatgpt-export"
OUT="$REPO/docs/obras/The_Character_of_Consciousness/pt/00_introducao.md"
mkdir -p "$(dirname "$OUT")"

cat > "$OUT" <<'MD'
---
title: "INTRODUÇÃO — THE CHARACTER OF CONSCIOUSNESS"
author: "David J. Chalmers"
lang: pt-BR
date: "2025-08-21"
---

# Introdução

Texto introdutório da obra *The Character of Consciousness* (David J. Chalmers).

> ⚠️ Este arquivo é apenas um **modelo inicial**.  
> Edite livremente no Typora para expandir o conteúdo acadêmico.

## Estrutura prevista

- Contextualização da obra e do autor.  
- Escopo e relevância acadêmica.  
- Estrutura das seis partes principais.  
- Contribuição para a filosofia da mente e ciências cognitivas.  

---

MD

echo "✅ Criado: $OUT"
