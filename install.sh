#!/bin/bash

# Configurações de cores para o output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}🚀 Iniciando Setup da Máquina do Jeff${NC}"
echo -e "${BLUE}==========================================${NC}"

# 1. Instalar Homebrew se não estiver presente
if ! command -v brew &> /dev/null; then
    echo -e "🍺 ${BLUE}Instalando Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configura o ambiente para Apple Silicon (M1/M2/M3) ou Intel
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "✅ ${GREEN}Homebrew já está instalado.${NC}"
fi

# 2. Atualizar o Brew
echo -e "🔄 ${BLUE}Atualizando o catálogo do Homebrew...${NC}"
brew update

# 3. Executar a instalação do Brewfile
if [ -f "Brewfile" ]; then
    echo -e "📦 ${BLUE}Instalando ferramentas do Brewfile...${NC}"
    # --no-lock evita criar arquivos temporários no seu repo git
    brew bundle --no-lock
else
    echo -e "❌ ${RED}Erro: Arquivo Brewfile não encontrado!${NC}"
    exit 1
fi

# 4. Cleanup
echo -e "🧹 ${BLUE}Limpando arquivos antigos do Homebrew...${NC}"
brew cleanup

echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}✨ Setup finalizado com sucesso!${NC}"
echo -e "${BLUE}Lembre-se de configurar seus arquivos .zshrc e config.fish${NC}"
echo -e "${BLUE}==========================================${NC}"