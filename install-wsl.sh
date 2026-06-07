#!/bin/bash

# --- CONFIGURAÇÕES DE UI (Mensagens Padronizadas) ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

LOG_DONE="✅ ${GREEN}"
LOG_INFO="🚀 ${BLUE}"
LOG_WARN="⚠️  ${YELLOW}"
LOG_ERR="❌ ${RED}"
LOG_TEMP="💡 ${BLUE}"
LOG_DIV="${BLUE}==========================================${NC}"

# --- INÍCIO DO SETUP ---

echo -e "$LOG_DIV"
echo -e "${GREEN}🚀 Iniciando Setup da Máquina do Jeff (WSL2)${NC}"
echo -e "$LOG_DIV"

# 0. Instalar dependências base para Homebrew no Linux
echo -e "${LOG_INFO}Instalando dependências base (apt)...${NC}"
sudo apt update && sudo apt install build-essential procps curl file git -y

# 1. Instalar Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${LOG_INFO}Instalando Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configurar Homebrew no PATH para Linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo -e "${LOG_DONE}Homebrew já está instalado.${NC}"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 2. Brew Bundle
echo -e "${LOG_INFO}Atualizando o catálogo do Homebrew...${NC}"
brew update

# Define o diretório dos dotfiles de forma segura
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DOTFILES_DIR"

if [ -f "Brewfile.wsl" ]; then
    echo -e "${LOG_INFO}Instalando ferramentas do Brewfile.wsl...${NC}"
    brew bundle --file=Brewfile.wsl --no-lock
else
    echo -e "${LOG_ERR}Erro: Arquivo Brewfile.wsl não encontrado!${NC}"
    exit 1
fi

# 3. Configuração do Node via FNM
echo -e "${LOG_INFO}Configurando Node.js LTS via FNM...${NC}"
if command -v fnm &> /dev/null; then
    eval "$(fnm env --shell bash)"
    fnm install --lts
    fnm default lts-latest
else
    echo -e "${LOG_WARN}Aviso: FNM não encontrado. Pulei o Node.${NC}"
fi

# 4. Criando Links Simbólicos (Symlinks)
echo -e "${LOG_INFO}Configurando Dotfiles (Symlinks)...${NC}"

# --- FISH ---
mkdir -p ~/.config/fish
if [ -f "$DOTFILES_DIR/.config/fish/config.fish" ]; then
    ln -sf "$DOTFILES_DIR/.config/fish/config.fish" "$HOME/.config/fish/config.fish"
    echo -e "${LOG_DONE}Config do Fish vinculada!${NC}"
else
    echo -e "${LOG_TEMP}Criando template de config.fish...${NC}"
    mkdir -p "$DOTFILES_DIR/.config/fish"
    echo "# Config Fish" > "$DOTFILES_DIR/.config/fish/config.fish"
    ln -sf "$DOTFILES_DIR/.config/fish/config.fish" "$HOME/.config/fish/config.fish"
fi

# --- ZSH ---
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    echo -e "${LOG_DONE}Config do Zsh vinculada!${NC}"
else
    echo -e "${LOG_TEMP}Criando template de .zshrc...${NC}"
    echo "# Config Zsh" > "$DOTFILES_DIR/.zshrc"
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

# --- NANO ---
if [ -f "$DOTFILES_DIR/.nanorc" ]; then
    ln -sf "$DOTFILES_DIR/.nanorc" "$HOME/.nanorc"
    echo -e "${LOG_DONE}Config do Nano vinculada!${NC}"
else
    echo -e "${LOG_TEMP}Criando template de .nanorc...${NC}"
    echo "set tabsize 4" > "$DOTFILES_DIR/.nanorc"
    ln -sf "$DOTFILES_DIR/.nanorc" "$HOME/.nanorc"
fi

# 5. Pastas de Trabalho
echo -e "${LOG_INFO}Criando diretórios de trabalho...${NC}"
mkdir -p ~/Workspaces/{mobile,front-end,python,java}
mkdir -p ~/workjs

# 6. Cleanup
brew cleanup

echo -e "$LOG_DIV"
echo -e "${LOG_DONE}Setup finalizado com sucesso, Jeff!${NC}"
echo -e "$LOG_DIV"
