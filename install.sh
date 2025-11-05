#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Termux Setup Complete - Instalador principal
# Autor: xLuffy025
# ============================================================

# 🎨 Colores
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[1;31m"
RESET="\033[0m"

# 🧩 Funciones de mensajes
msg(){ echo -e "${CYAN}==>${RESET} $1"; }
ok(){ echo -e "${GREEN}[✔]${RESET} $1"; }
warn(){ echo -e "${YELLOW}[!]${RESET} $1"; }
err(){ echo -e "${RED}[✖]${RESET} $1"; }

# ============================================================
# 📦 FUNCIONES PRINCIPALES
# ============================================================

actualizar(){
  msg "Actualizando Termux..."
  pkg update -y && pkg upgrade -y || err "Error al actualizar paquetes"
  termux-setup-storage
  ok "Termux actualizado."
}

instalar_basicos(){
  msg "Instalando paquetes esenciales..."
  bash scripts/install_packages.sh || err "Error al instalar paquetes básicos"
  ok "Dependencias básicas instaladas."
}

instalar_zsh(){
  msg "Instalando y configurando Zsh..."
  
  #Copia .p10k.zsh
  if [ -f "configs/.p10k.zsh" ]; then
    cp configs/.p10k.zsh ~/.p10k.zsh
    ok "copiando .p10k.zsh"
  fi

  bash scripts/install_zshxit.sh
  ok "Zsh configurado."
}

instalar_distros(){
  msg "Instalando distribuciones Proot..."
  bash scripts/install_pr-dis.sh 
  ok "Proot distros instaladas."
}

instalar_python_dev(){
  msg "Configurando entorno Python..."
  bash scripts/install_python.sh
  ok "Python dev configurado."
}

instalar_node_js(){
  msg "Instalando Node.js..."
  bash scripts/install_nodejs.sh
  ok "Node.js instalado."
}

instalar_vim_nvim(){
  msg "Configurando Vim y Neovim..."

  # Copiar .vimrc
  if [ -f "configs/.vimrc" ]; then
    cp configs/.vimrc ~/.vimrc
    ok "Archivo .vimrc instalado."
  fi

  # Instalar NvChad Starter
  bash scripts/install_nvim.sh
  ok "Neovim/NvChad configurado."
}

instalar_tmux(){
  msg "Instalando Tmux..."
  pkg install -y tmux
  if [ -f "configs/.tmux.conf" ]; then
    cp configs/.tmux.conf ~/.tmux.conf
    ok "Archivo .tmux.conf instalado."
  fi
}

limpiando_sistema(){
  msg "Limpiando sistema..."
  pkg autoclean && pkg clean && rm -rf ~/storage/downloads/*.deb 2>/dev/null || true
  ok "Sistema limpio."
}

configurar_dotfiles(){
  msg "Copiando scripts personalizados (dotfile)..."
  mkdir -p "$HOME/dotfile"

  local archivos=(
    "dotfiles/eyes.bnr"
    "dotfiles/clear-termux.sh"
    "dotfiles/update.sh"
    
  )

  for archivo in "${archivos[@]}"; do
    if [ -f "$archivo" ]; then
      cp "$archivo" "$HOME/dotfile/"
      ok "Copiado: $(basename "$archivo")"
    else
      warn "No se encontró: $archivo"
    fi
  done

  chmod +x "$HOME"/dotfiles/*.sh 2>/dev/null || true
  ok "dotfile instalados en ~/dotfile"
  echo
  echo -e "${CYAN}Puedes ejecutar:${RESET}"
  echo -e "  ${GREEN}bash ~/dotfile/clear-termux.sh${RESET}"
  echo -e "  ${GREEN}bash ~/dotfile/upgrade.sh${RESET}"
}

# ============================================================
# 🧠 INSTALACIÓN AUTOMÁTICA (modo silencioso)
# ============================================================
if [ "$1" == "--auto" ]; then
  actualizar
  instalar_basicos
  instalar_zsh
  instalar_distros
  instalar_python_dev
  instalar_node_js
  instalar_vim_nvim
  instalar_tmux
  configurar_dotfiles
  limpiando_sistema
  ok "Instalación automática completada ✅"
  exit 0
fi

# ============================================================
# 🧭 MENÚ INTERACTIVO
# ============================================================

mostrar_menu() {
  clear
  echo -e "${CYAN}╔═══════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}║     🚀 TERMUX SETUP INSTALLER         ║${RESET}"
  echo -e "${CYAN}╚═══════════════════════════════════════╝${RESET}"
  echo -e "${YELLOW}1)${RESET} Actualizar Termux"
  echo -e "${YELLOW}2)${RESET} Instalar paquetes básicos"
  echo -e "${YELLOW}3)${RESET} Instalar Zsh"
  echo -e "${YELLOW}4)${RESET} Instalar Proot-Distro"
  echo -e "${YELLOW}5)${RESET} Instalar Python dev"
  echo -e "${YELLOW}6)${RESET} Instalar Node.js"
  echo -e "${YELLOW}7)${RESET} Instalar Neovim/NvChad"
  echo -e "${YELLOW}8)${RESET} Instalar Tmux"
  echo -e "${YELLOW}9)${RESET} Copiar Dotfiles"
  echo -e "${YELLOW}10)${RESET} Limpiar sistema"
  echo -e "${YELLOW}0)${RESET} Salir"
  echo
}

while true; do
  mostrar_menu
  read -p "Selecciona una opción: " opt
  case $opt in
    1) actualizar ;;
    2) instalar_basicos ;;
    3) instalar_zsh ;;
    4) instalar_distros ;;
    5) instalar_python_dev ;;
    6) instalar_node_js ;;
    7) instalar_vim_nvim ;;
    8) instalar_tmux ;;
    9) configurar_dotfiles ;;
    10) limpiando_sistema ;;
    0) echo "Saliendo..."; exit 0 ;;
    *) err "Opción no válida." ;;
  esac
  read -p "Presiona Enter para continuar..."
done
