#!/usr/bin/env bash

if [ -n "$PREFIX" ] && [[ "$PREFIX" == *"com.termux"* ]]; then
    ENV="termux"
else
    ENV="linux"
fi

if [ "$ENV" = "linux" ]; then
    if command -v apt >/dev/null; then DISTRO="debian"
    elif command -v pacman >/dev/null; then DISTRO="arch"
    elif command -v dnf >/dev/null; then DISTRO="fedora"
    elif command -v yum >/dev/null; then DISTRO="rocky"
    else DISTRO="unknown"
    fi
else
    DISTRO="termux"
fi

export ENV DISTRO
export DOTFILES_DIR="$PWD/configs"
export NVIM_DIR="$HOME/.config/nvim"
