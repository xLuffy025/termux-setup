#!/usr/bin/env bash

# -------------------------------------------------------
#       Colores
# -------------------------------------------------------
GREEN="\033[1;32m"
YELLOW=
CYAN=
RED=
RESET=


#validar carpeta 
carpeta=~/nota
archivo=$carpeta/
# Crear carpeta si no existe 
mkdir -p "$carpeta"



# --------------------------------------------------------
#         Funcionea Principales
# --------------------------------------------------------
crear_nota() {

}

lista_notas() {

}

buscar_nota() {

}

editar_nota() {
  
}
eliminar_nota() {

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
  read -p "Sjeleccione una opcion" opt 
  case opt in
    1) crear_nota ;;
    2) lista_notas ;;
    3) buscar_nota ;;
    4) editar_nota ;;
    5) eliminar_nota ;;
    0) echo "Saliendo... "; exit 0 ;;
    *) err "opcion no valida." ;;
  esac
  
  read -p "Precione enter para continuar..."

done 

    
