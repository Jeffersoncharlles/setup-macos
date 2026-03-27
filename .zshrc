# ~/.zshrc

# --- Homebrew Setup ---
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# --- FNM (Node Manager) ---
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# --- Starship & Zoxide ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# --- Variáveis de Ambiente ---
export EDITOR="/opt/homebrew/bin/nano"
export VISUAL="/opt/homebrew/bin/nano"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Rust / Cargo
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# Outros Paths
export PATH="$HOME/.npm-packages/bin:$HOME/.lmstudio/bin:$HOME/.antigravity/antigravity/bin:$PATH"

# --- ALIASES (Espelhados do Fish) ---

# Navegação
alias l='ls -la'
alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias work="cd $HOME/Workspaces"
alias mobile="cd $HOME/Workspaces/mobile"
alias front="cd $HOME/Workspaces/front-end"
alias workpy="cd $HOME/Workspaces/python"
alias workjava="cd $HOME/Workspaces/java"
alias workjs="cd $HOME/workjs"

# Editors
alias z='zed .'
alias c='cursor .'
alias nano='/opt/homebrew/bin/nano'

# Aliases de Conventional Commits (Uso: gcfeat "shortcut nano")
alias gcfeat='git commit -m "feat: "'
alias gcfix='git commit -m "fix: "'
alias gcchore='git commit -m "chore: "'
alias gcrefact='git commit -m "refactor: "'
alias gcdocs='git commit -m "docs: "'
alias gcstyle='git commit -m "style: "'
alias gctest='git commit -m "test: "'

# Development & Docker
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dstart='docker start'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dexec='docker exec -it'

# PNPM & Node
alias ni='pnpm install'
alias nr='pnpm run'
alias ns='pnpm start'
alias nt='pnpm test'
alias nb='pnpm build'
alias node-update='fnm install --lts && fnm default lts-latest'

# System & Cleanup
alias cl='clear && echo "📦 Clean and ready!"'
alias restart-shell='exec zsh -l'
alias updatebrew='brew update && brew upgrade && brew cleanup'
alias cleanupnode='rm -rf node_modules && pnpm install'

# --- Configurações de Histórico do Zsh ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# --- Integrations ---
[[ -f "$HOME/.orbstack/shell/init2.zsh" ]] && source "$HOME/.orbstack/shell/init2.zsh" 2>/dev/null
[[ -f "$HOME/.turso/env.zsh" ]] && source "$HOME/.turso/env.zsh" 2>/dev/null