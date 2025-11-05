#!/data/data/com.termux/files/usr/bin/bash
# ======================================================
# Instalador completo de Termux + menú de distros
# ======================================================

set -e

# Colores
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

ok() { echo -e "${GREEN}[✔]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }

# --------------------------------------------
# FUNCIONES DE INSTALACIÓN
# --------------------------------------------

  pkg install -y proot-distro

# --------------------------------------------
# SUBMENÚ PROOT-DISTRO
# --------------------------------------------
  while true; do
    clear
    echo -e "${CYAN}===== MENÚ DE DISTROS PROOT =====${RESET}"
    echo "1) Instalar Arch Linux"
    echo "2) Instalar Manjaro"
    echo "3) Instalar Debian"
    echo "4) Instalar Ubuntu"
    echo "5) Instalar Fedora"
    echo "6) Instalar Rocky"
    echo "7) Instalar OpenSUSE"
    echo "8) Volver al menú principal"
    echo -n "Selecciona una opción: "
    read opt
    case $opt in
      1) proot-distro install archlinux && ok "Arch Linux instalado." ;;
      2) proot-distro install manjaro && ok "Ubuntu instalado." ;;
      3) proot-distro install debian && ok "Fedora instalado." ;;
      4) proot-distro install ubuntu && ok "Debian instalado." ;;
      5) proot-distro install fedora && ok "Debian instalado." ;;
      6) proot-distro install rockylinux && ok "Debian instalado." ;;
      7) proot-distro install opensuse && ok "OpenSUSE instalado." ;;
      8) break ;;
      *) warn "Opción inválida";;
    esac
    read -p "Presiona Enter para continuar..."
  done
