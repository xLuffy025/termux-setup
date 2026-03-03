#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SEPARADOR="===================================="

#----------------------------------------------------
# Colores 
#----------------------------------------------------
RESET="\e[0m"
ROJO="\e[31m"
VERDE="\e[32m"
AMARILLO="\e[33m"
AZUL="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BLANCO="\e[97m"
# ---------------------------------------------------
# Funciones de mensajes 
# ---------------------------------------------------
msg(){ printf "%b===>%b %s\n" "$CYAN" "$RESET" "$1"; }
ok(){ printf "%b [✅]%b %s\n" "$VERDE" "$RESET" "$1"; }
warn(){ printf "%b[!]>%b %s\n" "$AMARILLO" "$RESET" "$1"; } 
err(){ printf "%b[❌]%b %s\n" "$ROJO" "$RESET" "$1"; }

# ----------------------------------------------------
# Funcions Generales 
# ---------------------------------------------------
pausa() {
  read -p "Presione ENTER para continuar..."
}

cancelar_si_solicita() {
  local valor="$1"
  if [[ "$valor" == "0" ]]; then
    log_warn "Operación cancelada por el usuario"
    return 1
  fi
  return 0
}

confirmar() {
  local mensaje="$1"
  local respuesta 

  # Imprime la pregunta en amarillo para que resalte, sin salto de linea al final
  printf "%b¿%s? (s/n): %b" "$AMARILLO" "$mensaje" "$RESET"
  read -r respuesta

  # ${respuesta,,} convierte lo que escriba el usuario a minúscula automaticamente
  if [[ "${respuesta,,}" == "s" ]]; then
    return 0  # Confirmado
  else
    return 1  # Cancelado
  fi
}

# -------------------------------------------------------
# confirmaciones
# -------------------------------------------------------
confirmar_socios() {
  # Verificar si ahi socio registrados 
  [[ ! -s "$USUARIO_DIR/lista_usuarios.csv" ]] &&
    warn "No hay socios registrados." &&
    pausa && 
    return

  # Seleccionar socio por número 
  local socio=()
  local i=1
  while IFS= read -r linea; do 
    socio_nombre=$(echo "$linea" | cut -d',' -f1)
    socios+=("$socio_nombre")
    echo "$i) $socio_nombre"
    ((i++))
  done < "$USUARIO_DIR/lista_usuarios.csv"
}

# ----------------------------------------------------
# Funciones de interfas 
# ----------------------------------------------------
linea() {
  # Imprime la liena usando la variable pura y le aplica el color 
  printf "%b%s%b\n" "$CYAN" "$SEPARADOR" "$RESET"
}

linea_simple() {
  printf "%b-------------------------------------%b\n" "$CYAN" "$RESET"
}
titulo() {
  if [[ -t 1 ]]; then clear; fi
  linea

  local ancho_menu=${#SEPARADOR}
  local texto="$1"
  local longitud=${#texto}

  # Cálculo para centrar
  local padding=$(( (ancho_menu + longitud)/2))

  # Imprime el texto centrado con color 
  printf "%b%*s%b\n" "$MAGENTA" $padding "$texto" "$RESET"

