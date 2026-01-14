#!/data/data/com.termux/files/usr/bin/bash

# Colores
verde='\033[1;32m'
rojo='\033[1;31m'
reset='\033[0m'

echo -e "${verde}Registro de ejercicio completado${reset}"

# Pedir nivel
read -p "¿En qué nivel estás (1-6)? " nivel

# Validar nivel
if [[ "$nivel" =~ ^[1-5]$ ]]; then
  carpeta=~/termux-setup/dotfiles/practica_bash/proyectos/bash/nivel${nivel}
  archivo=$carpeta/completados.txt

  # Crear carpeta si no existe
  mkdir -p "$carpeta"

  # Pedir descripción del ejercicio
  read -p "Describe brevemente el ejercicio: " descripcion

  # Agregar entrada con fecha
  echo "$(date '+%Y-%m-%d %H:%M') - $descripcion" >> "$archivo"
  echo -e "${verde}✅ Ejercicio registrado en nivel $nivel${reset}"
else
  echo -e "${rojo}❌ Nivel inválido. Debe ser un número del 1 al 6.${reset}"
fi
