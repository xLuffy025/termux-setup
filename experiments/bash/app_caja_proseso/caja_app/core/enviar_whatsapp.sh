#!/usr/bin/env bash
set -euo pipefail

while true; do 
  clear 

  enviar_reporte_individual() {
    clear 
    titulo "Enviar reporte individual"

    cut -d',' -f1 "$USUARIO_DIR/lista_usuarios.csv"

    read -r -p "Nombre corto del socio: " socio

    [[ "$socio" == "0" ]] && return 

    tel=$(grep "^$socio," "$USUARIO_DIR/lista_usuarios.csv" | cut -d',' -f4)

    if [[ -z "$tel" ]]; then
      err "No se encontró teléfono para $socio"
      sleep 2 
      return
    fi 

    archivo=$(./reporte_individual.sh "$socio")

    if [[ ! -f "$archivo" ]]; then
      err "Error: el archivo no existe o la ruta es inválida."
      printf "Ruta recibida: %s\n" "$archivo"
      sleep 2
      return
    fi 

    if [[ "$archivo" == "ERROR_SOCIO" || -z "$archivo" ]]; then 
      err "Error al generar el reporte."
      sleep 2 
      return 
    fi 
    
    mkdir -p "$REPO_GITHUB_REPORTES"

    if [[ ! -f "$archivo" ]]; then
      err "Error: el archivo no existe."
      printf "Ruta recibida: %s\n" "$archivo"
      return
    fi 

    if [[ ! -d "$REPO_GITHUB_REPORTES" ]]; then
      err "Error: la carpeta destino no existe."
      printf "Ruta esperada: %s\n" "$REPO_GITHUB_REPORTES"
      return 
    fi 
    
    cp "$archivo" "$REPO_GITHUB_REPORTES/"

    cd "$REPO_GITHUB_REPORTES" || return
    sinc_github "Reporte enviado a $socio por WhatsApp"

    nombre_archivo=$(basename "$archivo")
    link="https://xluffy025.github.io/caja-2026-reportes/reportes/$nombre_archivo"

    mensaje="Hola $socio, aquí está tu estado de cuenta: $link"
    enviar_whatsapp_link "$tel" "$mensaje"

    cd - >/dev/null 2>&1
  }

  enviar_reportes_todos() {
    clear 
    titulo "Enviar reporte a todos los Socios"
    read -p "¿Continuar? (s/n): " resp
    [[ "$resp" != "s" && "$resp" != "S" ]] && return

    REPO=~/caja-2026-reportes 
    mkdir -p "$REPO/reportes"

    while IFS=',' read -r socio fecha clave tel resto; do 
      [[ -z "$socio" || "$socio" == "socio" ]] && continue

      echo "Procesando: $socio"
      
      archivo=$(./reporte_individual.sh "$socio")

      if [[ "$archivo" == "ERROR_SOCIO" || -z "$archivo" ]]; then
        err "Error, se omite."
        continue 
      fi 

      cp "$archivo" "$REPO/reportes/"

      nombre_archivo=$(basename "$archivo")
      link="https://xluffy025.github.io/caja-2026-reportes/reportes/$nombre_archivo"

      mensaje="Hola $socio, aquí está tu estado de cuenta: $link"

      if [[ -n "$tel" ]]; then
        enviar_whatsapp_link "$tel" "$mensaje"
      else 
        err "No hay teléfono registrado."
      fi

      echo

    done < "$USUARIO_DIR/lista_usuarios.csv"

    cd "$REPO" || return
    git pull
    git add .
    git commit -m "Reportes masivos actualizados" >/dev/null 2>&1
    git push >/dev/null 2>&1
    cd - >/dev/null 2>&1

    echo "Todos los reportes fueron generados y enviados."
    read -p "Enter para continuar..."
  }

  # Detectar entorno
  if grep -qi "android" /proc/version; then
    OPEN_URL="termux-open-url"
  elif grep -qi "microsoft" /proc/version; then
    OPEN_URL="wslview"
  else
    OPEN_URL="xdg-open"
  fi

  enviar_whatsapp_link() {
    tel="$1"
    mensaje="$2"
    url="https://wa.me/52$tel?text=$(printf '%s' "$mensaje" | sed 's/ /%20/g')"
    echo "Abriendo WhatsApp Web..."
    $OPEN_URL "$url"
  }

  probar_conexion_whatsapp() {
    echo -e "${VERDE}Abriendo WhatsApp Web...${RESET}"
    sleep 1 
    $OPEN_URL "https://wa.me/528996750648?text=Prueba%20de%20conexion"
  }

  clear
  echo -e "${CYAN}===========================${RESET}"
  echo -e "${MAGENTA}=== ENVÍO POR WHATSAPP ===${RESET}"
  echo -e "${CYAN}===========================${RESET}"
  echo "1) Enviar mensaje individual"
  echo "2) Enviar reporte a todos los socios"
  echo "3) Probar conexion"
  echo -e "${ROJO}(0 para cancelar)${RESET}"
  read -p "Solicitar una opción: " opcion
  cancelar_si_solicita "$opcion" || return 0

  case "$opcion" in 
    1) enviar_reporte_individual ;;  
    2) enviar_reportes_todos ;;  
    3) probar_conexion_whatsapp ;;  
    0) return;;
    *) echo -e "${ROJO}Opción inválida.${RESET}"; sleep 1 ;;
  esac
done
