#!/bin/bash

#Colores de mejor lectura
green="\e[32m"
red="\e[31m"
blue="\e[34m"
reset="\e[0m"

# Funciones de mensaje
ok() { echo -e "${gree}[✔️]${reset} $1"; }
err() { echo -e "${red}[❌]${reset} $1"; }
msg() { echo -e "${blue}==>${reset} $1"; }


msg "Instalando y configurando ZSH..."

# Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    ok "Oh My Zsh ya instalado."
fi

# Instalar plugins
PLUGINS_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins

msg "Instalando plugins ZSH..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${PLUGINS_DIR}/zsh-autosuggestions 2>/dev/null
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${PLUGINS_DIR}/zsh-syntax-highlighting 2>/dev/null
git clone https://github.com/marlonrichert/zsh-autocomplete ${PLUGINS_DIR}/zsh-autocomplete 2>/dev/null
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${PLUGINS_DIR}/fast-syntax-highlighting 2>/dev/null 



# Instalar Powerlevel10k
msg "Instalando tema Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc 2>/dev/null

# Copiar tu archivo .zshrc personalizado si existe en el repo
if [ -f "configs/.zshrc" ]; then
    cp configs/.zshrc ~/.zshrc
    ok "Archivo .zshrc personalizado instalado."
fi

chsh -s zsh || msg "No se pudo cambiar la shell por defecto."

ok "Zsh y Oh My Zsh configurados."
