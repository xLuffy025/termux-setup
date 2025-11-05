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

instalar_basicos(){
  msg "Instalando paquetes esenciales..."
  bash scripts/install_packages.sh || err "Error al instalar paquetes básicos"
  ok "Dependencias básicas instaladas."
}

instalar_zsh(){
  msg "Instalando y configurando Zsh..."
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
  msg "Instalando vim-plug y plugins para Vim/Neovim..."
  # vim-plug for vim
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || warn "Failed to install vim-plug for vim"

  # Run PlugInstall for vim
  if command -v vim >/dev/null 2>&1; then
    msg "Ejecutando PlugInstall en vim (headless)..."
    vim +'PlugInstall --sync' +qa || warn "vim PlugInstall falló"
  fi

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
  echo -e "${YELLOW}1)${RESET} Instalar paquetes básicos"
  echo -e "${YELLOW}2)${RESET} Instalar Zsh"
  echo -e "${YELLOW}3)${RESET} Instalar Proot-Distro"
  echo -e "${YELLOW}4)${RESET} Instalar Python dev"
  echo -e "${YELLOW}5)${RESET} Instalar Node.js"
  echo -e "${YELLOW}6)${RESET} Instalar Neovim/NvChad"
  echo -e "${YELLOW}7)${RESET} Instalar Tmux"
  echo -e "${YELLOW}8)${RESET} Copiar Dotfiles"
  echo -e "${YELLOW}9)${RESET} Limpiar sistema"
  echo -e "${YELLOW}0)${RESET} Salir"
  echo
}

while true; do
  mostrar_menu
  read -p "Selecciona una opción: " opt
  case $opt in
    1) instalar_basicos ;;
    2) instalar_zsh ;;
    3) instalar_distros ;;
    4) instalar_python_dev ;;
    5) instalar_node_js ;;
    6) instalar_vim_nvim ;;
    7) instalar_tmux ;;
    8) configurar_dotfiles ;;
    9) limpiando_sistema ;;
    0) echo "Saliendo..."; exit 0 ;;
    *) err "Opción no válida." ;;
  esac
  read -p "Presiona Enter para continuar..."
done
