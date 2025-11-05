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


# ==============================================
# 6️⃣ - CONFIGURAR NODEJS
# ==============================================
msg "Configurando Node.js..."

# Instalar Node.js 
pkg install -y nodejs

# Crear carpeta de proyecto
mkdir -p ~/mi-proyecto-node
cd ~/mi-proyecto-node

# Inicializar proyecto Node.js
npm init -y

# Instalar Express
npm install express

# Crear archivo index.js1
cat > index.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.send('¡Hola desde Node.js en Termux!');
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
EOF

#Crear Alias en la .zshrc si usas zsh 

if [ -f ~/.zshrc ]; then
cat << 'EOF' >> ~/.zshrc

# === Node.js Aliases ===
alias noj='nose index.js'

EOF
fi 

#Crea Alias en el .bashrc si usas bash

if [ -f ~/.bashrc ]; then 
cat << 'EOF' >> ~/bashrc

# === Node.js Aliases ===
alias noj='node index.js'

EOF
  fi 

# Ejecutar servidor
ok "Insatalando Node.js y creando un entorno ~/mi-proyecto-node/ se Ejecutara asi: (node index.js)"
