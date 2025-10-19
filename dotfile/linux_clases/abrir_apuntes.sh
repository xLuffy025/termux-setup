#!/data/data/com.termux/files/usr/bin/bash

# Colores
verde='\033[1;32m'
azul='\033[1;34m'
rojo='\033[1;31m'
amarillo='\033[1;33m'
reset='\033[0m'

# Frases motivadoras
frases=(
  "¡Cada comando te acerca a la maestría! 💪"
  "Tu terminal refleja tu evolución 🧠"
  "¡Sigue así, Jose! Estás construyendo algo grande 🚀"
  "La práctica hace al maestro... y tú lo estás logrando 🔧"
)

# Pedir nivel
read -p "¿Qué nivel quieres estudiar (1-5)? " nivel

archivo=~/linux_clases/nivel${nivel}/apuntes.md
registro=~/linux_clases/nivel${nivel}/completados.txt
meta=10

# Mostrar progreso visual
if [ -f "$registro" ]; then
  total=$(cat "$registro" | wc -l)
  porcentaje=$((total * 100 / meta))
  bloques=$((porcentaje / 10))
  barra=""
  for ((i=1; i<=10; i++)); do
    if [ $i -le $bloques ]; then
      barra+="▓"
    else
      barra+="░"
    fi
  done
  echo -e "\n${verde}Nivel $nivel:${reset} $total ejercicios completados"
  echo -e "Progreso: [$barra] $porcentaje%"
else
  echo -e "\n${rojo}Nivel $nivel:${reset} sin ejercicios registrados"
  echo -e "Progreso: [░░░░░░░░░░] 0%"
fi

# Mostrar frase motivadora aleatoria
frase=${frases[$RANDOM % ${#frases[@]}]}
echo -e "${amarillo}$frase${reset}"

# Ver o editar apuntes
if [ -f "$archivo" ]; then
  echo -e "\n${azul}¿Qué deseas hacer con tus apuntes?${reset}"
  echo "1) Ver con glow"
  echo "2) Editar con neovim"
  read -p "Elige una opción (1/2): " opcion

  case $opcion in
    1) glow "$archivo" ;;
    2) nvim "$archivo" ;;
    *) echo -e "${rojo}Opción inválida${reset}" ;;
  esac
else
  echo -e "${rojo}No existe el archivo de apuntes para nivel $nivel.${reset}"
fi
