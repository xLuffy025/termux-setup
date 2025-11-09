#!/usr/bin/env bash
# Universal environment detector (Termux / Proot / Linux)
# Autor: xLuffy025

set -u

# ==== Detect Termux ====
detect_termux() {
  [[ -d "/data/data/com.termux/files" && -n "${PREFIX:-}" && "$PREFIX" == *"com.termux"* ]]
}

# ==== Detect Proot ====
detect_proot() {
  if grep -q "/data/data/com.termux/files/usr" /proc/mounts 2>/dev/null; then
    return 0
  fi
  if [ ! -d /run/systemd/system ] && [ ! -f /sbin/init ]; then
    return 0
  fi
  if grep -q "proot" /proc/1/cmdline 2>/dev/null; then
    return 0
  fi
  if grep -q "archarm" /etc/os-release 2>/dev/null; then
    return 0
  fi
  return 1
}

# ==== Detect Distro ID ====
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "${ID,,}"
  else
    echo "unknown"
  fi
}

# ==== Detect Package Manager ====
detect_pkgmgr() {
  local env="$1"
  # Si es termux puro
  if [ "$env" = "termux" ]; then
    echo "pkg"
    return
  fi

  # Si es proot o linux real, prioriza según distro o binarios
  for p in pacman apt dnf yum zypper apk; do
    command -v "$p" >/dev/null 2>&1 && { echo "$p"; return; }
  done

  # Si todo falla, intenta fallback
  if command -v pkg >/dev/null 2>&1; then
    echo "pkg"
  else
    echo "unknown"
  fi
}

# ==== Detect User Privilege ====
if [ "$(id -u)" -eq 0 ]; then
  IS_ROOT=1; SUDO=""
else
  IS_ROOT=0; SUDO="sudo"
fi

# ==== Determine environment ====
if detect_termux; then
  if detect_proot; then
    ENV="proot"
  else
    ENV="termux"
  fi
else
  if detect_proot; then
    ENV="proot"
  else
    ENV="linux"
  fi
fi

OS_ID=$(detect_distro)
PKG=$(detect_pkgmgr "$ENV")

# ==== Export ====
export ENV OS_ID PKG IS_ROOT SUDO

# ==== Optional summary ====
if [ -t 1 ]; then
  echo -e "\n🌍 Entorno detectado: $ENV"
  echo -e "🐧 Distro: $OS_ID"
  echo -e "📦 Gestor: $PKG"
  echo -e "🔑 Root: $IS_ROOT\n"
fi
