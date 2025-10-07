#!/usr/bin/env bash
# setup-vim.sh — instalación y configuración de Neovim (NvChad Starter)

set -e

echo -e "\n🧠 Instalando Neovim y configurando NvChad Starter...\n"

# Dependencias básicas
pkg install -y neovim git curl

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

echo -e "\n✅ NvChad Starter instalado correctamente en ~/.config/nvim\n"
