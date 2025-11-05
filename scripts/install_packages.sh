#!/usr/bin/env bash

source "$(dirname "$0")/env.sh"

# -------- COLORS --------
GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"; RESET="\033[0m"
ok(){ echo -e "${GREEN}[✔]${RESET} $1"; }
warn(){ echo -e "${YELLOW}[!]${RESET} $1"; }
err(){ echo -e "${RED}[✖]${RESET} $1"; }

# -------- DETECT ROOT --------
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
  USER_MODE="root"
else
  SUDO="sudo"
  USER_MODE="user"
fi

# -------- DETECT DISTRO --------
detect_distro() {
  if command -v pkg >/dev/null 2>&1; then
    DISTRO="termux"
  elif command -v apt >/dev/null 2>&1; then
    DISTRO="debian"
  elif command -v pacman >/dev/null 2>&1; then
    DISTRO="arch"
  elif command -v dnf >/dev/null 2>&1; then
    DISTRO="fedora"
  elif command -v zypper >/dev/null 2>&1; then
    DISTRO="opensuse"
  else
    DISTRO="unknown"
  fi
}

detect_distro

echo -e "\nSistema detectado: ${GREEN}$DISTRO${RESET} ($USER_MODE)\n"

# -------- LISTA UNIVERSAL DE PAQUETES --------
BASE_PKGS=(
  git wget curl zsh build-essential openssh clang make pkg-config jq unzip \
  tar ripgrep fd tree htop rsync ncdu nmap net-tools socat screenfetch fastfetch \
  cowsay tmux
)

# -------- INSTALAR SEGÚN DISTRO --------
case "$DISTRO" in
  termux)
    pkg update -y && pkg upgrade -y
    pkg install -y "${BASE_PKGS[@]}" proot-distro termux-api root-repo x11-repo
    ;;

  debian)
    $SUDO apt update && $SUDO apt upgrade -y
    $SUDO apt install -y "${BASE_PKGS[@]}" build-essential
    ;;

  arch)
    $SUDO pacman -Syu --noconfirm
    $SUDO pacman -S --noconfirm "${BASE_PKGS[@]}" base-devel
    ;;

  fedora)
    $SUDO dnf update -y
    $SUDO dnf install -y "${BASE_PKGS[@]}" @development-tools
    ;;

  opensuse)
    $SUDO zypper refresh
    $SUDO zypper install -y "${BASE_PKGS[@]}" -t pattern devel_basis
    ;;

  *)
    err "Distribución no soportada automáticamente"
    exit 1
    ;;
esac

ok "Paquetes instalados correctamente ✅"
