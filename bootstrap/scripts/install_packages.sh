#!/usr/bin/env bash
# ============================================================
# install_packages.sh — Instalador universal de dependencias
# Usa la detección de entorno desde env.sh
# Autor: xLuffy025
# ============================================================

set -euo pipefail
IFS=$'\n\t'

# Cargar entorno
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/env.sh"

msg()  { echo -e "📦 ${1}"; }
ok()   { echo -e "✅ ${1}"; }
warn() { echo -e "⚠️ ${1}"; }
err()  { echo -e "❌ ${1}" >&2; }

msg "🔍 Detectando entorno..."
echo -e "🌍 Entorno: ${ENV} | 🐧 Distro: ${OS_ID} | 📦 Gestor: ${PKG}"

# ------------------------------------------------------------
# Instalador universal de paquetes base
# ------------------------------------------------------------

install_base_packages() {
  msg "Instalando paquetes esenciales para ${ENV}/${OS_ID}..."

  case "$PKG" in
    pkg)
      pkg update -y && pkg upgrade -y 
      pkg install git zsh tmux starship \
        clang make cmake ninja \
        python python-pip nodejs \
        rust golang php ruby \
        ripgrep fd eza bat lsd bc htop ranger ncdu jq \
        openssh rsync rclone curl wget \
        proot proot-distro \
        neovim vim termux-api build-essential unzip tar \
        ripgrep fd tree htop rsync ncdu nmap net-tools || warn "Algunos paquetes fallaron."
      ;;

    apt)-
      $SUDO apt update -y
      $SUDO apt install -y git curl wget zsh vim neovim tmux python3 python3-pip \
        nodejs npm build-essential jq unzip tar ripgrep fd-find tree htop rsync ncdu nmap || warn "Algunos paquetes fallaron."
      ;;

    pacman)
      $SUDO pacman -Sy --noconfirm --needed git curl wget zsh vim neovim tmux python nodejs npm \
        base-devel ripgrep fd tree htop rsync ncdu nmap || warn "Algunos paquetes fallaron."
      ;;

    dnf)
      $SUDO dnf install -y git curl wget zsh vim neovim tmux python3 python3-pip nodejs npm \
        @development-tools ripgrep fd-find tree htop rsync ncdu nmap || warn "Algunos paquetes fallaron."
      ;;

    yum)
      $SUDO yum install -y git curl wget zsh vim neovim tmux python3 python3-pip nodejs npm \
        make gcc jq unzip tar tree htop rsync || warn "Algunos paquetes fallaron."
      ;;

    apk)
      $SUDO apk add --no-cache git curl wget zsh vim neovim tmux python3 py3-pip nodejs npm \
        build-base jq tar ripgrep fd tree htop rsync ncdu nmap || warn "Algunos paquetes fallaron."
      ;;

    *)
      err "No se reconoce el gestor de paquetes (${PKG}). Debes instalar los paquetes manualmente."
      return 1
      ;;
  esac

  ok "Dependencias básicas instaladas con éxito en ${ENV} (${PKG})."
}

# ------------------------------------------------------------
# Instalador de dependencias opcionales (por rol)
# ------------------------------------------------------------

install_dev_tools() {
  msg "Instalando herramientas para desarrollo..."
  case "$PKG" in
    pkg|apt)
      $SUDO apt install -y gcc g++ make cmake gdb clang lldb python3-venv pipx || true
      ;;
    pacman)
      $SUDO pacman -S --noconfirm --needed gcc make cmake gdb clang lldb python-virtualenv || true
      ;;
    dnf|yum)
      $SUDO dnf install -y gcc-c++ make cmake gdb clang lldb python3-virtualenv || true
      ;;
  esac
  ok "Herramientas de desarrollo instaladas."
}

install_gui_tools() {
  msg "Instalando herramientas con GUI (solo para distros completas)..."
  case "$PKG" in
    apt)
      $SUDO apt install -y neofetch ranger || true
      ;;
    pacman)
      $SUDO pacman -S --noconfirm --needed neofetch ranger || true
      ;;
  esac
  ok "Herramientas gráficas instaladas (si aplica)."
}

# ------------------------------------------------------------
# Modo automático o interactivo
# ------------------------------------------------------------

if [[ "${1:-}" == "--auto" ]]; then
  msg "🚀 Instalación automática iniciada..."
  install_base_packages
  install_dev_tools
  ok "✅ Instalación automática completa."
else
  echo
  echo "=== MENU INSTALACIÓN DE PAQUETES ==="
  echo "1) Instalar paquetes base"
  echo "2) Instalar herramientas de desarrollo"
  echo "3) Instalar herramientas gráficas"
  echo "0) Salir"
  echo
  read -p "Selecciona una opción: " opt
  case $opt in
    1) install_base_packages ;;
    2) install_dev_tools ;;
    3) install_gui_tools ;;
    0) echo "Saliendo..." ;;
    *) warn "Opción inválida" ;;
  esac
fi 

