#!/data/data/com.termux/files/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# -----------------------
# termux-setup-complete.sh
# Instalador todo-en-uno para Termux:
# - update/upgrade
# - packages básicos
# - oh-my-zsh + powerlevel10k + plugins zsh-*
# - deploy dotfiles (desde GIT o carpeta local)
# - instalar proot-distro (ubuntu, fedora, arch)
# - crear entornos python y node (nvm)
# - instalar nvchad (opcional)
# Uso: EXPORTAR variables antes de ejecutar o pasarlas en la línea:
#   GIT_REPO="https://github.com/usuario/dotfiles.git" ./termux-setup-complete.sh
#   o
#   DOTFILES_DIR="./dotfiles-local" ./termux-setup-complete.sh
# -----------------------

# -------- CONFIGURACIÓN (edítalas si quieres) --------
GIT_REPO="${GIT_REPO:-}"       # si lo dejas vacío, usará DOTFILES_DIR o no clonará
DOTFILES_DIR="${DOTFILES_DIR:-}" # si existe, usará esta carpeta local (prioridad sobre GIT_REPO)
INSTALL_NVCHAD="${INSTALL_NVCHAD:-yes}" # yes/no
NVCHAD_REPO="${NVCHAD_REPO:-https://github.com/NvChad/NvChad}" # solo si deseas instalar nvchad
PY_VENV_BASE="${PY_VENV_BASE:-$HOME/.venvs}" # carpeta base para venvs
NODE_DEFAULT_VERSION="${NODE_DEFAULT_VERSION:-lts}" # "lts" o "18" etc.
# Lista de pip globales que quieres por defecto (se instala en cada venv si se activa)
PIP_PKGS="${PIP_PKGS:-requests beautifulsoup4 lxml tqdm colorama ipython rich pylint black flake8 isort autopep8 mypy}"
# ------------------------------------------------------

log() { echo -e "\033[1;36m[+] $*\033[0m"; }
err() { echo -e "\033[1;31m[!] $*\033[0m" >&2; }

# Comprueba entorno Termux
if [ -z "${PREFIX:-}" ]; then
  err "Parece que no estás en Termux. Este script está pensado para Termux."
  # seguimos igual, pero avisamos
fi

log "Actualizando paquetes..."
pkg update -y && pkg upgrade -y

log "Instalando paquetes base (git, zsh, curl, wget, python, node, proot-distro, neovim, tmux)..."
pkg install -y git zsh curl wget build-essential python python-pip nodejs proot-distro neovim tmux vim make clang pkg-config

# termux storage (si aún no está)
if ! grep -q termux-storage ~/../.. 2>/dev/null || true; then
  log "Ejecuta 'termux-setup-storage' manualmente si no has dado permisos de almacenamiento."
fi

# OH-MY-ZSH (no sobrescribe .zshrc si ya existe en dotfiles)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Instalando Oh My Zsh (modo unattended)..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
else
  log "Oh My Zsh ya instalado."
fi

# Powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
  log "Instalando Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
else
  log "Powerlevel10k ya existe."
fi

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

install_zsh_plugin() {
  local repo="$1"
  local name=$(basename "$repo")
  if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
    log "Clonando plugin zsh: $repo"
    git clone --depth=1 "https://github.com/$repo" "$ZSH_CUSTOM/plugins/$name"
  else
    log "Plugin $name ya existe."
  fi
}

install_zsh_plugin "zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-users/zsh-syntax-highlighting"
install_zsh_plugin "marlonrichert/zsh-autocomplete"

# Dotfiles: prioridad DOTFILES_DIR > GIT_REPO
WORK_DOTDIR="$HOME/dotfiles-deploy-temp"
if [ -n "$DOTFILES_DIR" ] && [ -d "$DOTFILES_DIR" ]; then
  log "Usando dotfiles desde carpeta local: $DOTFILES_DIR"
  rm -rf "$WORK_DOTDIR"
  cp -rT "$DOTFILES_DIR" "$WORK_DOTDIR"
elif [ -n "$GIT_REPO" ]; then
  log "Clonando dotfiles desde: $GIT_REPO"
  rm -rf "$WORK_DOTDIR"
  git clone --depth=1 "$GIT_REPO" "$WORK_DOTDIR"
else
  log "No se proporcionó DOTFILES_DIR ni GIT_REPO. No se copiarán dotfiles externos."
fi

# Si existen archivos en WORK_DOTDIR, linkear
if [ -d "$WORK_DOTDIR" ]; then
  log "Instalando dotfiles desde $WORK_DOTDIR ..."
  # lista de archivos a linkear si existen
  declare -a DOTFILES_TO_LINK=( ".zshrc" ".vimrc" ".tmux.conf" ".p10k.zsh" ".config/nvim" )
  for f in "${DOTFILES_TO_LINK[@]}"; do
    src="$WORK_DOTDIR/$f"
    dest="$HOME/$f"
    # si es carpeta nvim: manejamos distinto
    if [ -e "$src" ]; then
      # crear backup si existe
      if [ -e "$dest" ] || [ -L "$dest" ]; then
        log "Respaldando $dest -> $dest.backup"
        mv "$dest" "$dest.backup.$(date +%s)" || true
      fi
      mkdir -p "$(dirname "$dest")"
      log "Enlazando $src -> $dest"
      ln -s "$src" "$dest"
    fi
  done
else
  log "No hay dotfiles para instalar."
fi

# Forzar zsh como shell por defecto en termux (no hay chsh real)
log "Forzando zsh en inicio (añadiendo 'exec zsh' si no existe)..."
if ! grep -qxF 'exec zsh' ~/.bashrc 2>/dev/null; then
  echo 'exec zsh' >> ~/.bashrc
fi
if ! grep -qxF 'exec zsh' ~/.profile 2>/dev/null; then
  echo 'exec zsh' >> ~/.profile
fi

# Instalar Powerlevel10k en .zshrc si .zshrc no lo define (solo añade línea si falta)
if [ -f "$HOME/.zshrc" ] && ! grep -q "powerlevel10k" "$HOME/.zshrc"; then
  log "Añadiendo load de Powerlevel10k en ~/.zshrc"
  echo -e "\n# Powerlevel10k\nsource ~/powerlevel10k/powerlevel10k.zsh-theme\n" >> ~/.zshrc
fi

# Instalar tmux plugin manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Instalando TPM (tmux plugin manager)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  log "TPM ya instalado."
fi

# Proot-distro distros: ubuntu, fedora, arch (intenta nombres alternativos si falla)
log "Instalando proot-distro (si no está)..."
pkg install -y proot-distro || true

declare -a DISTROS=("ubuntu" "fedora" "archlinux" "arch")
for d in "${DISTROS[@]}"; do
  if proot-distro list | grep -qi "^$d" 2>/dev/null || true; then
    log "Intentando instalar/asegurar $d (si no está instalado ya)..."
  fi
  # instalar si no existe la carpeta /data/data/.../proot-distro/installed-distros/<d>
  if ! proot-distro list | grep -qi "$d"; then
    log "Agregando $d al listado (puede que el nombre exacto sea distinto)..."
  fi
  # Intentar instalar, ignorar fallos y probar nombre alternativo
  if ! proot-distro install "$d" 2>/dev/null; then
    log "No se pudo instalar $d (probablemente no disponible con ese nombre), se ignora."
  else
    log "$d instalado correctamente."
  fi
done

# Crear entornos python
mkdir -p "$PY_VENV_BASE"
log "Creando venv global: $PY_VENV_BASE/default"
python -m venv "$PY_VENV_BASE/default" || python3 -m venv "$PY_VENV_BASE/default"
# activar e instalar paquetes
# shellcheck disable=SC1090
source "$PY_VENV_BASE/default/bin/activate"
pip install --upgrade pip setuptools wheel
if [ -n "$PIP_PKGS" ]; then
  log "Instalando paquetes pip por defecto en venv: $PIP_PKGS"
  pip install $PIP_PKGS || log "Algunos paquetes no pudieron compilarse (advertencia)"
fi
pip freeze > "$PY_VENV_BASE/default/requirements.txt"
deactivate

# Node: instalando nvm y la versión por defecto
log "Instalando nvm (Node Version Manager)..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.6/install.sh | bash || true
else
  log "nvm ya instalado"
fi
# Cargar nvm en shell actual (si existe instalación)
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if command -v nvm >/dev/null 2>&1; then
  if [ "$NODE_DEFAULT_VERSION" = "lts" ]; then
    log "Instalando versión LTS de node..."
    nvm install --lts || true
    nvm alias default node || true
  else
    log "Instalando node $NODE_DEFAULT_VERSION ..."
    nvm install "$NODE_DEFAULT_VERSION" || true
    nvm alias default "$NODE_DEFAULT_VERSION" || true
  fi
else
  log "nvm no disponible ahora. Se usará nodejs del paquete (ya instalado)."
fi

# NVChad (opcional)
if [ "$INSTALL_NVCHAD" = "yes" ]; then
  if [ ! -d "$HOME/.config/nvim" ] || [ ! -d "$HOME/.config/nvim/.git" ]; then
    log "Instalando NvChad en ~/.config/nvim (se hará backup si existía)"
    if [ -d "$HOME/.config/nvim" ]; then
      mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
    fi
    git clone --depth=1 "$NVCHAD_REPO" ~/.config/nvim || log "Fallo clonando NvChad, verifica conexión"
  else
    log "NvChad ya instalado bajo ~/.config/nvim"
  fi
fi

# Neovim: instalar vim-plug para nvim si no existe
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  log "Instalando vim-plug para neovim..."
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || true
fi

# Opcional: subir dotfiles a git remoto (si especificas GIT_REMOTE_PUSH)
GIT_REMOTE_PUSH="${GIT_REMOTE_PUSH:-}"
if [ -n "$GIT_REMOTE_PUSH" ] && [ -d "$WORK_DOTDIR" ]; then
  log "Inicializando repo en $WORK_DOTDIR y subiendo a $GIT_REMOTE_PUSH"
  pushd "$WORK_DOTDIR" >/dev/null
  git init
  git add .
  git commit -m "dotfiles backup $(date -u +"%Y-%m-%dT%H:%M:%SZ")" || true
  git branch -M main || true
  git remote add origin "$GIT_REMOTE_PUSH" || git remote set-url origin "$GIT_REMOTE_PUSH"
  git push -u origin main --force || log "push fallido: revisa credenciales o token"
  popd >/dev/null
fi

# Mensajes finales
log "Instalación principal completada."
log "Siguientes pasos recomendados:"
cat <<'EOF'
1) Abre una nueva sesión de Termux (o ejecuta: source ~/.bashrc o ejecuta 'exec zsh')
2) Si usaste dotfiles desde un repo, revisa y ajusta ~/.zshrc y ~/.vimrc según prefieras.
3) Para activar el venv global: source ~/.venvs/default/bin/activate
4) Para usar nvm en nuevas sesiones: añade esto a tu ~/.zshrc:
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
5) Para instalar distros manualmente (si alguna no se instaló correctamente):
   proot-distro install ubuntu
   proot-distro install fedora
   proot-distro install archlinux
6) Para instalar plugins de tmux: abre tmux y presiona: Ctrl+b  I (mayúscula i)
7) Para Neovim (NvChad): abre nvim y sigue la guía de NvChad; o ejecuta :PackerSync si usa packer.
EOF

exit 0
