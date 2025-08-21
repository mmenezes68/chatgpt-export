#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURAÇÃO ===
# Caminho da ATA gerada (origem)
SRC="/Users/marcosmenezes/Desktop/Artigos_ProfessorWalter/The_Character_of_Consciousness_David_J_C_capítulos/ATA_005.md"

# Raiz do repositório onde estão as atas anteriores (ajuste se for diferente)
REPO="${REPO:-$HOME/chatgpt-export}"
DEST_DIR="$REPO/atas"
DEST="$DEST_DIR/ATA_005.md"

# Mensagem de commit
COMMIT_MSG="ATA 005: Instalação de pacotes ABNT e adicionais — expansão das possibilidades acadêmicas e técnicas"

# === CHECAGENS ===
if [[ ! -f "$SRC" ]]; then
  echo "ERRO: não encontrei a ata de origem em:"
  echo "  $SRC"
  exit 1
fi

if [[ ! -d "$REPO/.git" ]]; then
  echo "ERRO: '$REPO' não parece ser um repositório Git."
  exit 1
fi

mkdir -p "$DEST_DIR"

# === MOVER COM BACKUP (se já existir) ===
if [[ -f "$DEST" ]]; then
  ts="$(date +%Y%m%d-%H%M%S)"
  bk="$DEST.bak-$ts"
  echo "Aviso: já existe 'atas/ATA_005.md'. Fazendo backup em: $bk"
  cp "$DEST" "$bk"
fi

# Move (substitui o destino)
mv -f "$SRC" "$DEST"

# === COMMIT ===
cd "$REPO"
git add "atas/ATA_005.md"
git commit -m "$COMMIT_MSG"

echo "✅ ATA_005.md movida para: $DEST"
echo "✅ Commit criado em: $REPO"
echo "ℹ️  Se quiser enviar ao remoto:  cd \"$REPO\" && git push origin main   # ou o branch que você usa"
