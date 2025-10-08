#!/bin/bash

# Colores para mejor lectura
green="\e[32m"
red="\e[31m"
blue="\e[34m"
reset="\e[0m"

# Funciones de mensaje
ok() { echo -e "${green}[✔]${reset} $1"; }
err() { echo -e "${red}[✖]${reset} $1"; }
msg() { echo -e "${blue}==>${reset} $1"; }

msg "Instslando Python dev Setup..."
# === TERMUX PYTHON DEV SETUP ===
pkg install -y python-pip

# Crear entorno virtual global
python -m venv ~/.venv
source ~/.venv/bin/activate

# Actualizar pip y setuptools
pip install --upgrade pip setuptools wheel

# === Instalación de paquetes útiles ===
pip install requests beautifulsoup4 tqdm colorama
pip install ipython rich
pip install pylint black flake8 isort autopep8 mypy
pip install virtualenv virtualenvwrapper
pip install aiohttp selenium
pip install typer click loguru

# Guardar dependencias
pip freeze > ~/.venv/requirements.txt

# Crear alias en .zshrc (si usas zsh)
if [ -f ~/.zshrc ]; then
cat << 'EOF' >> ~/.zshrc

# === Python Dev Aliases ===
alias venv='source ~/.venv/bin/activate'
alias vexit='deactivate'
alias mkvenv='python -m venv ~/.venv && source ~/.venv/bin/activate && pip install --upgrade pip'
alias pyreq='pip freeze > requirements.txt && echo "Guardado en requirements.txt"'
alias pydev='source ~/.venv/bin/activate && echo "🐍 Entorno Python Dev activado"'

EOF
fi

# Crear alias en .bashrc (si usas bash)
if [ -f ~/.bashrc ]; then
cat << 'EOF' >> ~/.bashrc

# === Python Dev Aliases ===
alias venv='source ~/.venv/bin/activate'
alias vexit='deactivate'
alias mkvenv='python -m venv ~/.venv && source ~/.venv/bin/activate && pip install --upgrade pip'
alias pyreq='pip freeze > requirements.txt && echo "Guardado en requirements.txt"'
alias pydev='source ~/.venv/bin/activate && echo "🐍 Entorno Python Dev activado"'

EOF
fi

# Crear mensaje de bienvenida
echo 'echo "🐍 Python Dev listo: usa pydev para activar el entorno."' >> ~/.zshrc

# Limpiar cache
pip cache purge

ok "✅ Instalación completa. Reinicia Termux o ejecuta: source ~/.zshrc"
