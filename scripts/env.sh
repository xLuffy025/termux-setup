#!/usr/bin/env bash
# scripts/env.sh
# Detecta: termux / proot / linux, distro (ID), gestor de paquetes, root/user.
# Usar desde otros scripts con:
#   source "$(dirname "$0")/env.sh"
# o
#   source /ruta/a/scripts/env.sh

set -u

# ---------- Helpers ----------
_is_command() { command -v "$1" >/dev/null 2>&1; }

# Detect if running as root
if [ "$(id -u 2>/dev/null || echo 1)" -eq 0 ]; then
  IS_ROOT=1
  SUDO=""
else
  IS_ROOT=0
  SUDO="sudo"
fi

# Detect whether we are in Termux (quick but robust check)
# Termux installs under /data/data/com.termux/files and defines PREFIX; check both.
detect_termux() {
  if [ -n "${PREFIX:-}" ] && [[ "${PREFIX}" == *"com.termux"* ]] && [ -d "/data/data/com.termux/files" ]; then
    return 0
  fi
  return 1
}

# Detect proot: check /proc/1/cmdline and /proc/1/comm for "proot"
detect_proot() {
  # if /proc/1 exists
  if [ -r /proc/1/cmdline ]; then
    if tr '\0' ' ' < /proc/1/cmdline 2>/dev/null | grep -q -E '(^|/)(proot|proot-)|(proot)'; then
      return 0
    fi
  fi
  if [ -r /proc/1/comm ]; then
    if tr -d '\n' < /proc/1/comm 2>/dev/null | grep -q -E '^proot'; then
      return 0
    fi
  fi
  return 1
}

# Detect distro ID by reading /etc/os-release (works inside proot too)
detect_distro_id() {
  if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    # ID may be like "ubuntu", "debian", "arch"; normalize to lowercase
    echo "${ID,,}"
  else
    echo "unknown"
  fi
}

# Detect package manager best-effort
detect_pkgmgr() {
  if detect_termux; then
    echo "pkg"
    return
  fi

  if _is_command apt; then echo "apt" && return; fi
  if _is_command pacman; then echo "pacman" && return; fi
  if _is_command dnf; then echo "dnf" && return; fi
  if _is_command yum; then echo "yum" && return; fi
  if _is_command zypper; then echo "zypper" && return; fi

  echo "unknown"
}

# ---------- Main detection ----------
# Default ENV value
ENV="linux"
PROOT=0

if detect_termux; then
  # Could be Termux native, but maybe user started a proot-distro inside Termux.
  # Check if we appear to be inside a proot session
  if detect_proot; then
    ENV="proot"
    PROOT=1
  else
    ENV="termux"
    PROOT=0
  fi
else
  # Not a basic Termux prefix — might be real linux or proot if launched differently
  if detect_proot; then
    ENV="proot"
    PROOT=1
  else
    ENV="linux"
    PROOT=0
  fi
fi

# Distro ID (works for linux and proot)
OS_ID="$(detect_distro_id)"

# Package manager
PKG="$(detect_pkgmgr)"

# Export for scripts that source this file
export ENV PROOT OS_ID PKG IS_ROOT SUDO

# Also export some convenience booleans/strings
export IS_TERMUX=$([ "$ENV" = "termux" ] && echo 1 || echo 0)
export IS_PROOT=$([ "$ENV" = "proot" ] && echo 1 || echo 0)
export IS_LINUX=$([ "$ENV" = "linux" ] && echo 1 || echo 0)

# Provide a small summary when sourced interactively (not when sourced by non-interactive scripts)
if [ -t 1 ]; then
  printf "\n[env] Entorno detectado: %s (proot=%s)  distro: %s  pkg: %s  is_root: %s\n\n" \
    "$ENV" "$PROOT" "$OS_ID" "$PKG" "$IS_ROOT"
fi
