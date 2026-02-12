#!/data/data/com.termux/files/usr/bin/bash

# Colores
verde='\033[1;32m'
azul='\033[1;34m'
rojo='\033[1;31m'
reset='\033[0m'

# Saludo
echo -e "${azul}¡Hola Jose! 🧑‍💻 Bienvenido a tu terminal Linux${reset}"
echo -e "Fecha: $(date '+%A %d %B %Y - %H:%M')"
echo -e "Distribución activa: ${verde}$(uname -a | cut -d' ' -f1)${reset}"
echo ""

# Función para mostrar barra de progreso
mostrar_barra() {
  nivel=$1
  archivo=~/termux-setup/dotfiles/linux_clases/nivel${nivel}/completados.txt
  meta=5  # puedes cambiar esto si quieres más ejercicios por nivel

  if [ -f "$archivo" ]; then
    total=$(cat "$archivo" | wc -l)
    porcentaje=$((total * 100 / meta))
    bloques=$((porcentaje / 5))
    barra=""
    for ((i=1; i<=5; i++)); do
      if [ $i -le $bloques ]; then
        barra+="▓"
      else
        barra+="░"
      fi
    done
    echo -e "${verde}Nivel $nivel:${reset} $total ejercicios completados"
    echo -e "Progreso: [$barra] $porcentaje%"
  else
    echo -e "${rojo}Nivel $nivel:${reset} sin progreso aún"
    echo -e "Progreso: [░░░░░░░░░░] 0%"
  fi
  echo ""
}

# Mostrar progreso por niveles
for i in {1..5}; do
  mostrar_barra $i
done

# Frase motivadora
echo -e "${azul}Sigue así, tu terminal refleja tu evolución 🧠🔥${reset}"
