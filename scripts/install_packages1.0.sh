#!/bin/bash

# ================================
# 🔍 DETECTAR SISTEMA Y USUARIO
# ================================

# Detectar si se está en Termux
if [ -n "$PREFIX" ] && [[ "$PREFIX" == *com.termux* ]]; then
    SYSTEM="termux"
    PKG_MANAGER="pkg"
elif [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
        ubuntu|debian)
            SYSTEM="debian"
            PKG_MANAGER="apt"
            ;;
        arch|manjaro)
            SYSTEM="arch"
            PKG_MANAGER="pacman"
            ;;
        fedora)
            SYSTEM="fedora"
            PKG_MANAGER="dnf"
            ;;
        *)
            SYSTEM="unknown"
            PKG_MANAGER=""
            ;;
    esac
else
    SYSTEM="unknown"
    PKG_MANAGER=""
fi

# Detectar si se ejecuta como root o usuario normal
if [ "$(id -u)" -eq 0 ]; then
    USER_TYPE="root"
else
    USER_TYPE="user"
fi

echo "🧠 Sistema detectado: $SYSTEM"
echo "⚙️  Gestor de paquetes: $PKG_MANAGER"
echo "👤 Usuario: $USER_TYPE"
echo

# ================================
# 📦 FUNCIÓN UNIVERSAL PARA INSTALAR
# ================================

install_packages() {
    local packages=("$@")

    case "$SYSTEM" in
        termux)
            pkg update -y && pkg upgrade -y
            pkg install -y "${packages[@]}"
            ;;
        debian)
            sudo apt update -y && sudo apt upgrade -y
            sudo apt install -y "${packages[@]}"
            ;;
        arch)
            sudo pacman -Sy --noconfirm "${packages[@]}"
            ;;
        fedora)
            sudo dnf install -y "${packages[@]}"
            ;;
        *)
            echo "❌ Sistema no compatible o no detectado."
            return 1
            ;;
    esac
}

# ================================
# 🚀 EJEMPLO DE USO
# ================================

BASIC_PKGS=(curl git wget nano unzip)

echo "Instalando paquetes básicos..."
install_packages "${BASIC_PKGS[@]}"
echo "✅ Instalación completa."

