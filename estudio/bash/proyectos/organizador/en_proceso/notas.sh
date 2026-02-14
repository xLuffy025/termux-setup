#!/usr/bin/env bash

# -------------------------------------------------------
#       Colores
# -------------------------------------------------------
VERDE="\e[32m"
AMARILLO="\e[33m"
CYAN="\e[36m"
ROJO="\e[31m"
AZUL="\e[34m"
MAGENTA="\e[35m"
BLANCO="\e[97m"
RESET="\e[0m"

# -------------------------------------------------------
#       Funciones de Mensajes 
# -------------------------------------------------------
msg(){ echo -e "${CYAN}==>${RESET} $1"; }
ok(){ echo -e "${VERDE}[✔️] ${RESET}  $1"; }
warn(){ echo -e "${AMARILLO} [!]${RESET} $1"; }
err(){ echo -e "${ROJO} [✖️] ${RESET} $1"; } 

# --------------------------------------------------------
#
# --------------------------------------------------------


#validar carpeta 
DATA_DIR="~/nota"
NOTA_MD="$DATA_DIR/nota.md"
# Crear carpeta si no existe 
mkdir -p "$carpeta"



# --------------------------------------------------------
#         Funciones Principales
# --------------------------------------------------------
crear_nota() {
    nvim +"autocmd BufWritePre * call RenameWithTitle()"
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
  read -p "Seleccione una opcion: " opt 
  case $opt in
    1) crear_nota ;;
    2) lista_notas ;;
    3) buscar_nota ;;
    4) editar_nota ;;
    5) eliminar_nota ;;
    0) echo "Saliendo... "; exit 0 ;;
    *) err "opcion no valida." ;;
  esac
  
  read -p "Presione Enter para continuar..."

done 

    
