# Setup macOS - Jefferson

Repositório pessoal para configurar um Mac do zero com foco em desenvolvimento React, Next.js, Node.js, React Native, Docker/OrbStack e ferramentas de IA no terminal.

A ideia principal é manter as configurações centralizadas dentro do próprio repositório, seguindo o padrão `.config`. O `$HOME` recebe apenas links simbólicos quando alguma ferramenta exige compatibilidade.

## O que este setup faz

O script principal `install.sh`:

1. Instala o Homebrew se necessário.
2. Instala ferramentas do `Brewfile`.
3. Cria diretórios base como `~/.config`, `~/.local` e `~/Workspaces`.
4. Linka os diretórios de `.config` do repositório para `~/.config`.
5. Cria symlinks de compatibilidade para Zsh, Git, Nano e Tmux.
6. Configura Node.js LTS via `fnm`.
7. Configura `pnpm`.
8. Define Fish como shell padrão.
9. Oferece a opção de rodar `install-github.sh` para configurar Git/GitHub.

O script `install-github.sh` fica separado porque envolve dados pessoais, como nome, e-mail de commit e chave SSH.

## Estrutura

```txt
setup-macos/
├── Brewfile
├── install.sh
├── install-github.sh
├── README.md
├── .gitignore
└── .config/
    ├── fish/
    │   └── config.fish
    ├── zsh/
    │   ├── .zshenv
    │   └── .zshrc
    ├── git/
    │   ├── config.example
    │   └── ignore_global
    ├── nano/
    │   └── nanorc
    ├── opencode/
    │   ├── opencode.example.json
    │   └── README.md
    ├── claude/
    │   ├── settings.example.json
    │   └── README.md
    ├── starship/
    └── tmux/
        └── tmux.conf
```

## Regra principal

Toda configuração real deve ficar dentro deste repositório em:

```txt
.config/
```

Exemplos:

```txt
.config/fish/config.fish
.config/zsh/.zshrc
.config/git/config.example
.config/opencode/opencode.example.json
.config/claude/settings.example.json
```

Depois da instalação, o script cria links como:

```txt
~/.config/fish      -> ~/setup-macos/.config/fish
~/.config/zsh       -> ~/setup-macos/.config/zsh
~/.config/opencode  -> ~/setup-macos/.config/opencode
~/.config/claude    -> ~/setup-macos/.config/claude
```

E também links de compatibilidade:

```txt
~/.zshenv           -> ~/setup-macos/.config/zsh/.zshenv
~/.zshrc            -> ~/setup-macos/.config/zsh/.zshrc
~/.gitconfig        -> ~/setup-macos/.config/git/config
~/.gitignore_global -> ~/setup-macos/.config/git/ignore_global
~/.nanorc           -> ~/setup-macos/.config/nano/nanorc
~/.tmux.conf        -> ~/setup-macos/.config/tmux/tmux.conf
```

## Instalação em um Mac novo

Primeiro instale as ferramentas de linha de comando da Apple:

```bash
xcode-select --install
```

Depois clone o repositório:

```bash
cd ~
git clone https://github.com/SEU-USUARIO/setup-macos.git
cd setup-macos
```

Dê permissão de execução:

```bash
chmod +x install.sh install-github.sh
```

Rode o setup principal:

```bash
./install.sh
```

Ao final, feche e abra o terminal novamente.

## Git/GitHub separado

Durante o `install.sh`, ele pergunta se você quer configurar Git/GitHub agora.

Se responder `N`, ele pula essa parte. Depois você pode rodar manualmente:

```bash
./install-github.sh
```

Esse script:

1. Pergunta seu nome para commits Git.
2. Pergunta seu e-mail para commits Git.
3. Cria `.config/git/config` localmente.
4. Linka para `~/.gitconfig`.
5. Linka `.config/git/ignore_global` para `~/.gitignore_global`.
6. Opcionalmente cria uma chave SSH `ed25519`.
7. Opcionalmente roda `gh auth login` se o GitHub CLI estiver instalado.

## E-mail recomendado para GitHub

Se o repositório for público, não use necessariamente seu Gmail real nos commits.

Prefira o e-mail privado do GitHub, no formato:

```txt
12345678+seuusuario@users.noreply.github.com
```

Você encontra em:

```txt
GitHub > Settings > Emails > Keep my email addresses private
```

## Segurança

Este repositório foi preparado para ser público.

Arquivos reais e sensíveis ficam ignorados no `.gitignore`, como:

```txt
.config/git/config
.config/claude/*
.config/opencode/*
```

O repositório versiona apenas arquivos de exemplo:

```txt
.config/git/config.example
.config/claude/settings.example.json
.config/opencode/opencode.example.json
```

Não coloque tokens, senhas, chaves privadas, arquivos de sessão ou credenciais reais neste repositório.

## Node.js

O Node.js é gerenciado pelo `fnm`, não pelo Homebrew.

O script executa:

```bash
fnm install --lts
fnm default lts-latest
```

## Bancos de dados

Este setup não instala PostgreSQL, Redis, MySQL ou MongoDB via Homebrew.

A ideia é usar bancos por Docker/OrbStack em cada projeto, via `docker-compose.yml`.

## Atualização

Para atualizar pacotes do Homebrew:

```bash
brew update && brew upgrade && brew cleanup
```

Ou usando o alias:

```bash
updatebrew
```

Para atualizar Node LTS:

```bash
node-update
```
