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
msg "Actualizando Termux..."
pkg update -y && pkg upgrade -y || err "Error al actualizar paquetes"

# ==============================================
# 2️⃣ - INSTALAR PAQUETES BÁSICOS
# ==============================================
instalar_basicos(){
msg "Instalando paquetes esenciales..."
pkg install -y git wget curl build-essential python nodejs openssh vim neovim tmux zsh proot-distro termux-api root-repo x11-repo unstable-repo clang make pkg-config jq unzip tar ripgrep fd tree htop rust rsync ncdu nmap net-tools socat screenfetch proot ffmpg imagenmagick openvpn neofech cowsay  || err "Error al instalar paquetes básicos"
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
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 2>/dev/null

# Copiar tu archivo .zshrc personalizado si existe en el repo
if [ -f "configs/.zshrc" ]; then
    cp configs/.zshrc ~/.zshrc
    ok "Archivo .zshrc personalizado instalado."
fi

chsh -s zsh || msg "No se pudo cambiar la shell por defecto."
ok "Zsh y Oh My Zsh configurados."
}

# ==============================================
# 4️⃣ - ENTORNOS PROOT
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
instalar_python_env(){
msg "Configurando entorno Python..."
pip install --upgrade pip virtualenv wheel rich requests || err "Error al instalar dependencias de Python"

# Crear entorno virtual global
if [ ! -d "$HOME/.venv" ]; then
    python -m venv ~/.venv
    ok "Entorno virtual Python creado en ~/.venv"
fi

# ==============================================
# 6️⃣ - CONFIGURAR NODEJS
# ==============================================
msg "Configurando Node.js..."
npm install -g npm yarn pnpm http-server neovim || err "Error al instalar paquetes Node"

# ==============================================
# 7️⃣ - CONFIGURAR NEOVIM / VIM
# ==============================================
msg "Configurando Vim y Neovim..."

# Copiar .vimrc personalizado si existe
if [ -f "configs/.vimrc" ]; then
    cp configs/.vimrc ~/.vimrc
    ok "Archivo .vimrc instalado."
fi

# Instalar NvChad Starter si no existe
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "🌀 Instalando NvChad Starter..."
  git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1
  ok "NvChad Starter instalado correctamente."
else
  ok "NvChad ya estaba instalado."
fi

# ==============================================
# 8️⃣ - LIMPIEZA FINAL
# ==============================================
msg "Limpiando sistema..."
pkg autoclean && pkg clean && rm -rf ~/storage/downloads/*.deb || true

ok "Instalación completa. Reinicia Termux o ejecuta:"
echo -e "${BLUE}zsh${RESET}"
