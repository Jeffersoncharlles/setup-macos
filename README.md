# 🛠️ Jeff's Dotfiles & Machine Setup

Este repositório contém a automação completa para configurar meu ambiente de desenvolvimento no macOS. Ele utiliza **Homebrew Bundle** para gerenciar pacotes, linguagens e ferramentas de infraestrutura.

## 📋 Pré-requisitos

- macOS (Intel ou Apple Silicon).
- Conexão com a internet.
- Git configurado (ou baixar o repo como ZIP).

## 🚀 Como Instalar

Para configurar a máquina do zero, abra o terminal e execute:

```bash
# Clone o repositório (ajuste o link se for privado via SSH)
git clone [https://github.com/Jeffersoncharlles/setup-macos](https://github.com/Jeffersoncharlles/setup-macos.git) ~/dotfiles

# Entre na pasta
cd ~/dotfiles

# Dê permissão de execução ao script
chmod +x install.sh

# Execute o setup
./install.sh