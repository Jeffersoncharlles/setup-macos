#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Setup Git/GitHub - Jefferson
# Script separado para dados pessoais/local.
# Pode ser rodado pelo install.sh ou manualmente depois.
# ==========================================================

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

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/.config"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

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

ask_input() {
  local prompt="$1"
  local default_value="${2:-}"
  local value=""

  if [ -n "$default_value" ]; then
    read -r -p "$prompt [$default_value]: " value
    echo "${value:-$default_value}"
  else
    read -r -p "$prompt: " value
    echo "$value"
  fi
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

write_gitignore_global() {
  local file="$CONFIG_DIR/git/ignore_global"

  if [ -f "$file" ]; then
    done_msg "Git ignore global já existe em: $file"
    return 0
  fi

  cat > "$file" <<'EOF_GITIGNORE'
# ==========================================================
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
.continue/
EOF_GITIGNORE

  done_msg "Git ignore global criado em: $file"
}

write_git_config_example() {
  local file="$CONFIG_DIR/git/config.example"

  if [ -f "$file" ]; then
    return 0
  fi

  cat > "$file" <<'EOF_GITCONFIG_EXAMPLE'
[user]
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
    fs = flow support
EOF_GITCONFIG_EXAMPLE

  done_msg "Git config example criado em: $file"
}

write_git_config() {
  local file="$CONFIG_DIR/git/config"

  if [ -f "$file" ]; then
    if ! ask_yes_no "Já existe .config/git/config. Deseja recriar com novos dados?" "N"; then
      done_msg "Mantendo Git config existente."
      return 0
    fi
  fi

  echo -e "${LOG_TEMP}Para repo público, prefira o e-mail noreply do GitHub.${NC}"
  echo -e "${LOG_TEMP}Exemplo: 12345678+seuusuario@users.noreply.github.com${NC}"
  echo -e "${LOG_TEMP}Se deixar nome ou e-mail em branco, esta etapa será pulada.${NC}"

  local git_name
  local git_email

  git_name="$(ask_input "Nome para commits Git" "")"
  git_email="$(ask_input "Email para commits Git" "")"

  if [ -z "$git_name" ] || [ -z "$git_email" ]; then
    warn "Nome ou e-mail vazio. Git config pessoal não foi criado."
    warn "Você pode rodar ./install-github.sh depois para concluir."
    return 0
  fi

  cat > "$file" <<EOF_GITCONFIG
[user]
    name = $git_name
    email = $git_email

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
    fs = flow support
EOF_GITCONFIG

  done_msg "Git config pessoal criado em: $file"
}

setup_ssh_key() {
  if ! ask_yes_no "Deseja criar/configurar chave SSH para GitHub agora?" "N"; then
    warn "SSH pulado. Você pode configurar depois."
    return 0
  fi

  local email="$1"
  local key_file="$HOME/.ssh/id_ed25519"

  ensure_dir "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if [ -f "$key_file" ]; then
    warn "Chave já existe: $key_file"
  else
    if [ -z "$email" ]; then
      email="$(ask_input "Comentário/e-mail para a chave SSH" "")"
    fi

    if [ -z "$email" ]; then
      warn "Comentário vazio. Pulando criação da chave SSH."
      return 0
    fi

    ssh-keygen -t ed25519 -C "$email" -f "$key_file" -N ""
    done_msg "Chave SSH criada: $key_file"
  fi

  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy < "$key_file.pub"
    done_msg "Chave pública copiada para a área de transferência."
  else
    warn "pbcopy não encontrado. Copie manualmente a chave abaixo."
  fi

  echo -e "$LOG_DIV"
  echo -e "${YELLOW}Adicione esta chave no GitHub:${NC}"
  echo -e "${YELLOW}GitHub > Settings > SSH and GPG keys > New SSH key${NC}"
  echo -e "$LOG_DIV"
  cat "$key_file.pub"
  echo -e "$LOG_DIV"

  if command -v gh >/dev/null 2>&1; then
    if ask_yes_no "Deseja rodar gh auth login agora?" "N"; then
      gh auth login
    fi
  fi
}

# ==========================================================
# Run
# ==========================================================

echo -e "$LOG_DIV"
echo -e "${GREEN}🚀 Configurando Git/GitHub${NC}"
echo -e "$LOG_DIV"

cd "$DOTFILES_DIR"
ensure_dir "$CONFIG_DIR/git"

write_git_config_example
write_gitignore_global
write_git_config

link_path "$CONFIG_DIR/git/ignore_global" "$HOME/.gitignore_global"
if [ -f "$CONFIG_DIR/git/config" ]; then
  link_path "$CONFIG_DIR/git/config" "$HOME/.gitconfig"
fi

# Pega o e-mail do config criado, se existir, só para sugerir na chave SSH.
GIT_EMAIL=""
if [ -f "$CONFIG_DIR/git/config" ]; then
  GIT_EMAIL="$(git config --file "$CONFIG_DIR/git/config" user.email || true)"
fi

setup_ssh_key "$GIT_EMAIL"

echo -e "$LOG_DIV"
done_msg "Git/GitHub finalizado."
echo -e "$LOG_DIV"

if [ -d "$BACKUP_DIR" ]; then
  warn "Alguns arquivos antigos foram movidos para:"
  echo -e "${YELLOW}$BACKUP_DIR${NC}"
fi
