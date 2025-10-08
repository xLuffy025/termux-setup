#!/usr/bin/env bash

# Colores para mejor lectura
green="\e[32m"
red="\e[31m"
blue="\e[34m"
reset="\e[0m"

# Funciones de mensaje
ok() { echo -e "${green}[✔]${reset} $1"; }
err() { echo -e "${red}[✖]${reset} $1"; }
msg() { echo -e "${blue}==>${reset} $1"; }

# ------------------------------
# FUNCIONES DE INSTALACIÓN
# ------------------------------

msg "Instalando Neovim y configurando NvChad Starter..."

set -e

echo -e "\n🧠 Instalando Neovim y configurando NvChad Starter...\n"

# Dependencias básicas
pkg install -y neovim

# Verifica si ya existe ~/.config/nvim
if [ -d "$HOME/.config/nvim" ]; then
  echo "⚠️  Ya existe una instalación de Neovim en ~/.config/nvim"
  read -p "¿Deseas reemplazarla por NvChad Starter? (s/n): " answer
  if [[ "$answer" =~ ^[sS]$ ]]; then
    rm -rf ~/.config/nvim
    echo "🧹 Instalación anterior eliminada..."
  else
    echo "❌ Saltando instalación de NvChad..."
    exit 0
  fi
fi

# Clonar NvChad Starter
echo -e "\n📦 Clonando NvChad Starter...\n"
git clone https://github.com/NvChad/starter ~/.config/nvim

# Primer arranque (instala plugins automáticamente)
echo -e "\n🚀 Iniciando Neovim para completar la configuración...\n"
nvim --headless +"Lazy sync" +qa

ok "\n✅ NvChad Starter instalado correctamente en ~/.config/nvim\n"
