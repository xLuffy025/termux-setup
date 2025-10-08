#!/data/data/com.termux/files/usr/bin/bash
# ==============================================
# Termux Setup Complete - Instalador principal
# Autor: xLuffy025
# ==============================================

# Colores
GREEN="\e[32m"
BLUE="\e[34m"
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"

# Función para mensajes
msg() { echo -e "${CYAN}[*]${RESET} $1"; }
ok() { echo -e "${GREEN}[✓]${RESET} $1"; }
err() { echo -e "${RED}[✗]${RESET} $1"; }

# ==============================================
# 1️⃣ - ACTUALIZAR TERMUX
# ==============================================
actualizar(){
msg "Actualizando Termux..."
pkg update -y && pkg upgrade -y || err "Error al actualizar paquetes"
}
# ==============================================
# 2️⃣ - INSTALAR PAQUETES BÁSICOS
# ==============================================
instalar_basicos(){
msg "Instalando paquetes esenciales..."
pkg install -y git wget curl build-essential python openssh vim neovim zsh proot-distro termux-api root-repo x11-repo clang make pkg-config jq unzip tar ripgrep fd tree htop rust rsync ncdu nmap net-tools socat screenfetch proot fastfetch cowsay  || err "Error al instalar paquetes básicos"
ok "Dependencias basicas instaladas."
}
# ==============================================
# 3️⃣ - CONFIGURAR ZSHH
# ==============================================
instalar_zsh(){
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
}

# ==============================================
# 4️⃣ - ENTORNOS PPOORTF-DISTROOS   
# ==============================================
instalar_distros(){
msg "Instalando distribuciones Proot..."
proot-distro install archlinux || true
proot-distro install ubuntu || true
proot-distro install fedora || true
proot-distro install debian || true

ok "Proot distros instaladas."
}

# ==============================================
# 5️⃣ - CONFIGURAR PYTHON
# ==============================================
instalar_python_dev(){
  bash scripts/install_python.sh 
}

# ==============================================
# 6️⃣ - CONFIGURAR NODEJS
# ==============================================
instalar_node_js(){
  bash scripts/install_nodejs.sh
}

# ==============================================
# 7️⃣ - CONFIGURAR NEOVIM / VIM
# ==============================================
instalar_vim_nvim(){
msg "Configurando Vim y Neovim..."

# Copiar .vimrc personalizado si existe
if [ -f "configs/.vimrc" ]; then
    cp configs/.vimrc ~/.vimrc
    ok "Archivo .vimrc instalado."
fi

# Instalar NvChad Starter si no existe

bash scripts/install_nvim.sh 
}

# ==============================================
# 8 INSATALECION DE TMUX
# ==============================================
instalar_tmux(){
msg "Instalar_Tmux"
pkg install -y tmux

if [ -f "configs/.tmux.conf" ]; then
    cp configs/.tmux.conf ~/.tmux.conf
    ok "Archivo .tmux.conf instalado."
fi 
}


# ==============================================
# 8️⃣ - LIMPIEZA FINAL
# ==============================================
limpiando_sistema(){
msg "Limpiando sistema..."
pkg autoclean && pkg clean && rm -rf ~/storage/downloads/*.deb || true

if [ -f "configs/eyes.bnr" ]; then
    cp configs/eyes.bnr ~/eyes.bnr 

ok "Instalación completa. Reinicia Termux o ejecuta:"
echo -e "${BLUE}zsh${RESET}"
fi
}

# ------------------------------
# MENÚ PRINCIPAL
# ------------------------------

while true; do
  clear
  echo -e "${blue}"
  echo "============================="
  echo " 🧰 TERMUX SETUP INSTALLER"
  echo "============================="
  cat ~/termux-setup/scripts/eyes.bnr 
  echo -e "${reset}"
  echo "1) Actuatlizar Termux"
  echo "2) Instalar Dependencias basicas"
  echo "3) Instalar Zsh"
  echo "4) Instalar proot-distro"
  echo "5) Instalar Python dev"
  echo "6) Instalar Node.js"
  echo "7) Instalar Vim/Nvim + NvCha"
  echo "8) Instalar Tmux"
  echo "9) Limpiando Sistema"
  echo "0) Salir"
  echo "============================="
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
    9) limpiando_sistema ;;
    0) echo "👋 Saliendo del instalador..."; exit 0 ;;
    *) err "Opción no válida." ;;
  esac

  echo
  read -p "Presiona Enter para continuar..."
done

