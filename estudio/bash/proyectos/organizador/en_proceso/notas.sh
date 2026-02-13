#!/usr/bin/env bash

# -------------------------------------------------------
#       Colores
# -------------------------------------------------------
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[1;31m"
RESET="\033[1;0m"

# -------------------------------------------------------
#       Funciones de Mensajes 
# -------------------------------------------------------
msg(){ echo -p "${CYAN}==>${RESET} $1"; }
ok(){ echo -p "${GREEN}[✔️] ${RESET}  $1"; }
warn(){ echo -p "${YELLOW} [!]${RESET} $1"; }
err(){ echo -p "${RED} [✖️] ${RESET} $1"; } 

# --------------------------------------------------------
#
# --------------------------------------------------------


#validar carpeta 
carpeta=~/nota
archivo=$carpeta/
# Crear carpeta si no existe 
mkdir -p "$carpeta"



# --------------------------------------------------------
#         Funciones Principales
# --------------------------------------------------------
crear_nota(){
  msg "En proceso"

}

lista_notas(){
  msg "En proceso"

}

buscar_nota(){
  msg "En proceso"

}

editar_nota(){
  msg "En proceso"
  
}

eliminar_nota(){
  msg "En proceso"

}
# --------------------------------------------------------
#         Menu Interactivo
# --------------------------------------------------------
mostrar_menu() {
  clear 
  echo -e "${CYAN}╔═══════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}║     🚀   Notas Mackdown               ║${RESET}"
  echo -e "${CYAN}╚═══════════════════════════════════════╝${RESET}"
  echo -e "${YELLOW}1)${RESET} Crear Nota" 
  echo -e "${YELLOW}2)${RESET} Listar Notas"
  echo -e "${YELLOW}3)${RESET} Buscar por palabra"
  echo -e "${YELLOW}4)${RESET} Editar Nota"
  echo -e "${YELLOW}5)${RESET} Eliminar nota"
  echo -e "${YELLOW}0)${RESET} Salir"
  echo

}

while true; do
  mostrar_menu
  read -p "Seleccione una opcion" opt 
  case $opt in
    1) crear_nota ;;
    2) lista_notas ;;
    3) buscar_nota ;;
    4) editar_nota ;;
    5) eliminar_nota ;;
    0) echo "Saliendo... "; exit 0 ;;
    *) err "opcion no valida." ;;
  esac
  
  read -p "Presione enter para continuar..."

done 

    
