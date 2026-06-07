#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Setup macOS - Jefferson
# Instala Homebrew, Brewfile, Node via FNM e configura dotfiles
# Regra principal: configs reais ficam no repo dentro de .config/
# ==========================================================

# --- UI COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

LOG_DONE="✅ ${GREEN}"
LOG_INFO="🚀 ${BLUE}"
LOG_WARN="⚠️  ${YELLOW}"
LOG_ERR="❌ ${RED}"
LOG_TEMP="💡 ${BLUE}"
LOG_DIV="${BLUE}==========================================${NC}"

# --- PATHS ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/.config"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# ==========================================================
# Helpers
# ==========================================================

info() { echo -e "${LOG_INFO}$1${NC}"; }
done_msg() { echo -e "${LOG_DONE}$1${NC}"; }
warn() { echo -e "${LOG_WARN}$1${NC}"; }
err() { echo -e "${LOG_ERR}$1${NC}"; }

ensure_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    done_msg "Diretório criado: $dir"
  fi
}

ensure_file() {
  local file="$1"
  local content="$2"

  if [ ! -f "$file" ]; then
    mkdir -p "$(dirname "$file")"
    printf "%s\n" "$content" > "$file"
    done_msg "Arquivo criado: $file"
  fi
}

create_backup() {
  local target="$1"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
    warn "Backup criado para: $target"
  fi
}

link_path() {
  local source="$1"
  local target="$2"

  if [ ! -e "$source" ]; then
    warn "Origem não encontrada, pulando: $source"
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  create_backup "$target"

  ln -sfn "$source" "$target"
  done_msg "Link criado: $target -> $source"
}

ask_yes_no() {
  local question="$1"
  local default_answer="${2:-N}"
  local answer=""

  read -r -p "$question [$default_answer]: " answer
  answer="${answer:-$default_answer}"

  case "$answer" in
    y|Y|yes|YES|s|S|sim|SIM) return 0 ;;
    *) return 1 ;;
  esac
}

# ==========================================================
# Base templates públicos/seguros
# ==========================================================

create_base_templates() {
  info "Garantindo estrutura .config dentro do repo..."

  ensure_dir "$CONFIG_DIR"
  ensure_dir "$CONFIG_DIR/fish"
  ensure_dir "$CONFIG_DIR/zsh"
  ensure_dir "$CONFIG_DIR/git"
  ensure_dir "$CONFIG_DIR/nano"
  ensure_dir "$CONFIG_DIR/opencode"
  ensure_dir "$CONFIG_DIR/claude"
  ensure_dir "$CONFIG_DIR/starship"
  ensure_dir "$CONFIG_DIR/tmux"

  ensure_file "$CONFIG_DIR/zsh/.zshenv" '# ~/.config/zsh/.zshenv

# Força o Zsh a buscar configs dentro de ~/.config/zsh
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"'

  ensure_file "$CONFIG_DIR/fish/config.fish" '# ~/.config/fish/config.fish

# Config Fish do Jeff
# Substitua este template pela sua config completa.'

  ensure_file "$CONFIG_DIR/zsh/.zshrc" '# ~/.config/zsh/.zshrc

# Config Zsh do Jeff
# Substitua este template pela sua config completa.'

  ensure_file "$CONFIG_DIR/git/config.example" '[user]
    name = Seu Nome
    email = seu-usuario@users.noreply.github.com

[core]
    editor = nano
    autocrlf = input
    excludesfile = ~/.gitignore_global
    quotepath = false

[init]
    defaultBranch = main

[color]
    ui = auto

[pull]
    rebase = true

[push]
    autoSetupRemote = true
    default = current

[fetch]
    prune = true
    pruneTags = true

[branch]
    sort = -committerdate

[tag]
    sort = -version:refname

[diff]
    algorithm = histogram
    colorMoved = plain
    mnemonicPrefix = true
    renames = true

[merge]
    conflictstyle = zdiff3

[rerere]
    enabled = true

[rebase]
    autoStash = true
    updateRefs = true

[help]
    autocorrect = 20

[alias]
    s = status -sb
    st = status
    c = commit -m
    ca = commit --amend
    cane = commit --amend --no-edit

    p = push
    pf = push --force-with-lease
    pl = pull
    rb = rebase
    rbc = rebase --continue
    rba = rebase --abort

    co = checkout
    cob = checkout -b
    br = branch
    bd = branch -d
    bD = branch -D

    l = log --oneline --graph --decorate --all
    last = log -1 HEAD --stat
    unstage = reset HEAD --
    discard = checkout --

    ff = flow feature
    fr = flow release
    fh = flow hotfix
    fs = flow support'

  ensure_file "$CONFIG_DIR/git/ignore_global" '# ==========================================================
# Global Git Ignore
# macOS / Editors / Node / React / Next / Logs / Local env
# ==========================================================

# macOS
.DS_Store
.AppleDouble
.LSOverride
Icon?
._*
.Spotlight-V100
.Trashes
.fseventsd
.VolumeIcon.icns

# Temporary files
Thumbs.db
ehthumbs.db
Desktop.ini
*.swp
*.swo
*~
*.tmp
*.temp

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Environment files
.env
.env.*
!.env.example
!.env.sample
!.env.template

# Node / package managers
node_modules/
.pnpm-store/
.npm/
.yarn/*
!.yarn/releases
!.yarn/plugins
!.yarn/sdks
!.yarn/versions

# Build outputs
dist/
build/
out/
coverage/
.nyc_output/
.cache/
.parcel-cache/
.turbo/
.vercel/
.netlify/

# Next.js / React / Vite
.next/
vite.config.ts.timestamp-*
vite.config.js.timestamp-*

# TypeScript
*.tsbuildinfo

# Testing
playwright-report/
test-results/
cypress/videos/
cypress/screenshots/

# Editors / IDEs
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json

.idea/
*.iml

# Local databases / runtime files
*.sqlite
*.sqlite3
*.db
*.db-journal
*.pid
*.seed
*.pid.lock

# Docker local override
docker-compose.override.yml
compose.override.yml

# Certificates / keys
*.pem
*.key
*.crt
*.p12
*.pfx
id_rsa
id_rsa.pub
id_ed25519
id_ed25519.pub

# Archives
*.zip
*.tar
*.tar.gz
*.tgz
*.rar
*.7z

# AI local files
.claude/
.cursor/
.continue/'

  ensure_file "$CONFIG_DIR/nano/nanorc" 'set tabsize 4
set tabstospaces
set linenumbers
set mouse'

  ensure_file "$CONFIG_DIR/tmux/tmux.conf" 'set -g mouse on
set -g history-limit 10000'

  ensure_file "$CONFIG_DIR/opencode/opencode.example.json" '{
  "$schema": "https://opencode.ai/config.json"
}'

  ensure_file "$CONFIG_DIR/claude/settings.example.json" '{
  "theme": "dark"
}'
}

# ==========================================================
# Header
# ==========================================================

echo -e "$LOG_DIV"
echo -e "${GREEN}🚀 Iniciando Setup da Máquina do Jeff${NC}"
echo -e "$LOG_DIV"

cd "$DOTFILES_DIR"

# ==========================================================
# 1. Homebrew
# ==========================================================

if ! command -v brew >/dev/null 2>&1; then
  info "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  done_msg "Homebrew já está instalado."
fi

# Garante brew no PATH depois da instalação
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ==========================================================
# 2. Brew Bundle
# ==========================================================

if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  info "Atualizando catálogo do Homebrew..."
  brew update

  info "Instalando ferramentas do Brewfile..."
  brew bundle --file "$DOTFILES_DIR/Brewfile" --no-lock
else
  err "Brewfile não encontrado em: $DOTFILES_DIR/Brewfile"
  exit 1
fi

# ==========================================================
# 3. Estrutura base do sistema e repo
# ==========================================================

info "Criando estrutura base..."

ensure_dir "$HOME/.config"
ensure_dir "$HOME/.local"
ensure_dir "$HOME/.local/bin"
ensure_dir "$HOME/.local/share"
ensure_dir "$HOME/.cache"
ensure_dir "$HOME/.local/state"

ensure_dir "$HOME/Workspaces"
ensure_dir "$HOME/Workspaces/mobile"
ensure_dir "$HOME/Workspaces/front-end"
ensure_dir "$HOME/workjs"

create_base_templates

# ==========================================================
# 4. Symlinks XDG - tudo dentro de ~/.config
# ==========================================================

info "Configurando dotfiles em ~/.config..."

for item in "$CONFIG_DIR"/*; do
  [ -e "$item" ] || continue
  name="$(basename "$item")"
  link_path "$item" "$HOME/.config/$name"
done

# ==========================================================
# 5. Symlinks de compatibilidade
# ==========================================================

info "Criando symlinks de compatibilidade..."

# ZSH: ~/.zshenv aponta o ZDOTDIR para ~/.config/zsh
link_path "$CONFIG_DIR/zsh/.zshenv" "$HOME/.zshenv"
link_path "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Git: config real é criado pelo install-github.sh
link_path "$CONFIG_DIR/git/ignore_global" "$HOME/.gitignore_global"
if [ -f "$CONFIG_DIR/git/config" ]; then
  link_path "$CONFIG_DIR/git/config" "$HOME/.gitconfig"
else
  warn "Git config pessoal ainda não existe. Rode ./install-github.sh quando quiser configurar."
fi

# Nano / Tmux / Starship
link_path "$CONFIG_DIR/nano/nanorc" "$HOME/.nanorc"
link_path "$CONFIG_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

if [ -f "$CONFIG_DIR/starship/starship.toml" ]; then
  link_path "$CONFIG_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
fi

# ==========================================================
# 6. Git/GitHub opcional
# ==========================================================

if [ -x "$DOTFILES_DIR/install-github.sh" ]; then
  if ask_yes_no "Deseja configurar Git/GitHub agora? Se pular, rode ./install-github.sh depois" "N"; then
    "$DOTFILES_DIR/install-github.sh"
  else
    warn "Configuração Git/GitHub pulada. Você pode rodar depois: ./install-github.sh"
  fi
fi

# ==========================================================
# 7. Node.js via FNM
# ==========================================================

info "Configurando Node.js LTS via FNM..."

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash)"
  fnm install --lts
  fnm default lts-latest
  done_msg "Node LTS configurado com FNM."
else
  warn "FNM não encontrado. Node.js não foi instalado."
fi

# ==========================================================
# 8. PNPM
# ==========================================================

info "Configurando PNPM..."

if command -v pnpm >/dev/null 2>&1; then
  pnpm setup || true
  done_msg "PNPM configurado."
else
  warn "PNPM não encontrado."
fi

# ==========================================================
# 9. Fish como shell padrão
# ==========================================================

info "Verificando Fish como shell padrão..."

if command -v fish >/dev/null 2>&1; then
  FISH_PATH="$(command -v fish)"

  if ! grep -q "$FISH_PATH" /etc/shells; then
    warn "Adicionando Fish em /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi

  if [ "${SHELL:-}" != "$FISH_PATH" ]; then
    warn "Alterando shell padrão para Fish..."
    chsh -s "$FISH_PATH"
    done_msg "Fish definido como shell padrão. Reinicie o terminal depois."
  else
    done_msg "Fish já é o shell padrão."
  fi
else
  warn "Fish não encontrado."
fi

# ==========================================================
# 10. Cleanup
# ==========================================================

info "Limpando cache do Homebrew..."
brew cleanup || true

# ==========================================================
# Final
# ==========================================================

echo -e "$LOG_DIV"
done_msg "Setup finalizado com sucesso, Jeff!"
echo -e "$LOG_DIV"

if [ -d "$BACKUP_DIR" ]; then
  warn "Alguns arquivos antigos foram movidos para:"
  echo -e "${YELLOW}$BACKUP_DIR${NC}"
fi

echo -e "${LOG_TEMP}Reinicie o terminal para carregar tudo corretamente.${NC}"
