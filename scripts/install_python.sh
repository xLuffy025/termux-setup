#!/bin/bash

# === TERMUX PYTHON DEV SETUP ===
pkg install -y python-pip

# Crear entorno virtual global
mkdir ~/proyecto/python 
cd ~/proyecto/python
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
pip install numpy matplotlib seaborn scikit-learn jupyter
pip install typer click loguru fastapi uvicorn

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

echo "✅ Instalación completa. Reinicia Termux o ejecuta: source ~/.zshrc"
