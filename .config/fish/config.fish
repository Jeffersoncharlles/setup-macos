if status is-interactive
    # --- Greeting & Prompt ---
    set -U fish_greeting "🐟"
    starship init fish | source
    
    # --- Homebrew Setup ---
    # Detecta automaticamente o caminho do Brew (Apple Silicon ou Intel)
    if test -d /opt/homebrew/bin
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else if test -d /usr/local/bin/brew
        eval "$(/usr/local/bin/brew shellenv)"
    end

    # --- FNM (Node Manager) Setup ---
    # --use-on-cd troca a versão do Node automaticamente ao entrar na pasta do projeto
    if type -q fnm
        fnm env --use-on-cd --shell fish | source
    end

    # --- Zoxide (Substituto do cd) ---
    if type -q zoxide
        zoxide init fish | source
    end
end

# --- Variáveis de Ambiente e Paths (Portáveis com $HOME) ---
set SPACEFISH_PROMPT_ADD_NEWLINE false

# EDITOR: Definindo o nano do Homebrew como padrão
set -gx EDITOR /opt/homebrew/bin/nano
set -gx VISUAL /opt/homebrew/bin/nano

# Turso
if test -e $HOME/.turso/env.fish
    source $HOME/.turso/env.fish
end

# Rust / Cargo
if test -d $HOME/.cargo/bin
    fish_add_path "$HOME/.cargo/bin"
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path "$PNPM_HOME"

# Android SDK
set -gx ANDROID_HOME "$HOME/Library/Android/Sdk"
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path $ANDROID_HOME/platform-tools

# Outros Paths
fish_add_path "$HOME/.npm-packages/bin"
fish_add_path "$HOME/.lmstudio/bin"
fish_add_path "$HOME/.antigravity/antigravity/bin"

# Aliases de Conventional Commits (Uso: gcfeat "shortcut nano")
alias gcfeat='git commit -m "feat: "'
alias gcfix='git commit -m "fix: "'
alias gcchore='git commit -m "chore: "'
alias gcrefact='git commit -m "refactor: "'
alias gcdocs='git commit -m "docs: "'
alias gcstyle='git commit -m "style: "'
alias gctest='git commit -m "test: "'

# Iniciar uma nova funcionalidade (Ex: gff start minha-task)
alias gff='git flow feature'
alias gfr='git flow release'
alias gfh='git flow hotfix'

# Atalhos rápidos para as ações mais comuns
alias gffs='git flow feature start'
alias gfff='git flow feature finish'
alias gffp='git flow feature publish'

# --- ALIASES: Navegação ---
alias l='ls -la'
alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias work="cd $HOME/Workspaces"
alias mobile="cd $HOME/Workspaces/mobile"
alias front="cd $HOME/Workspaces/front-end"
alias workpy="cd $HOME/Workspaces/python"
alias workjava="cd $HOME/Workspaces/java"
alias workjs="cd $HOME/workjs"

# --- ALIASES: Editors ---
alias z='zed .'
alias c='cursor .'
alias nano='/opt/homebrew/bin/nano'

# --- ALIASES: Development & Tools ---
alias hostsssh="cat $HOME/.ssh/known_hosts"
alias opensslpriv='openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048'
alias opensslpubl='openssl rsa -pubout -in private_key.pem -out public_key.pem'
alias setconfnode='npm pkg set engines.node=$(node -v) author=jeffersoncharlles type=module'

# --- ALIASES: Docker ---
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dstart='docker start'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dexec='docker exec -it'

# --- ALIASES: PNPM & Node ---
alias ni='pnpm install'
alias nr='pnpm run'
alias ns='pnpm start'
alias nt='pnpm test'
alias nb='pnpm build'
alias node-update='fnm install --lts && fnm default lts-latest'

# --- ALIASES: System & Cleanup ---
alias cl='clear && echo "📦 Clean and ready!"'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias cleanupnode='rm -rf node_modules && pnpm install'
alias cleanupgit='git clean -fd && git reset --hard'
alias updatebrew='brew update && brew upgrade && brew cleanup'
alias ports='lsof -i -P -n | grep LISTEN'
alias ip='ipconfig getifaddr en0'
alias myip='curl ifconfig.me'
alias restart-shell='exec $SHELL -l'
alias camera='nohup bash camera_monitor.sh > /dev/null 2>&1 &'

# --- ALIASES: Productivity ---
alias now='date +"%T"'
alias today='date +"%A, %B %d, %Y"'
alias wttr='curl wttr.in'
alias cal='cal -3'
alias speed='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias httpserver='python3 -m http.server 8000'

# --- fzf Configuration ---
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --glob "!.git/*"'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_T_OPTS "
    --style full
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# --- Integrations ---
if test -e $HOME/.orbstack/shell/init2.fish
    source $HOME/.orbstack/shell/init2.fish
end