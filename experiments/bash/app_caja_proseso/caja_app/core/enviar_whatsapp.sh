#!/usr/bin/env bash
set -euo pipefail

while true; do 
  clear 

  enviar_reporte_individual() {
    clear 
    titulo "Enviar reporte individual"

    cut -d',' -f1 "$USUARIO_DIR/lista_usuarios.csv"

    read -r -p "Nombre corto del socio" socio

    [[ "$socio" == "0" ]] && return 

    tel=$(grep "^$socio," "$USUARIO_DIR/lista_usuarios.csv" | cut -d',' -f4)

    if [[ -z "$tel" ]]; then
      err "No se encontró teléfono para $socio"
      sleep 2 
      return
    fi 

    archivo=$(./reporte_individual.sh "$socio")

    if [[ ! -f "archivo" ]]; then
      err "Error: el achivo no existe o la ruta es inválida."
      printf "Ruta recibida: $archivo"
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
      printf "Ruta recibida: $archivo"
      return
    fi 

    if [[ ! -d "$REPO_GITHUB_REPORTES" ]]; then
      err "Error: la carpeta destino no existe."
      printf "Ruta esperada: $REPO_GITHUB_REPORTES"
      return 
    fi 
    
    cp "$archivo" "$REPO_GITHUB_REPORTES/"

    cd "$REPO_GITHUB_REPORTES" || return
    sinc_github "Reporte enviado a $socio por WhatsApp"

    nombre_archivo=$(basename "$archivo")
    link"https://xluffy025.github.io/caja-2026-reportes/reportes/$nombre_archivo"

    mensaje="Hola $socio, aqui esta tu estado de cuenta: $link"
    enviar_whatsapp_link "$tel" "$mensaje"

    cd - >/dev/null 2>&1
  }

  enviar_reporte_todos() {
    clear 
    titulo "Enviar reporte a todos los Socios"
    confirmar 

    REPO=~/caja-2026-reportes 
    mkdir -p "$REPO/reportes"

    while IFS=',' read -r socio fecha clave tel resto; do 
      [[ -z "$socio" || $socio == "socio" ]] && continue

      echo "Procesando: $socio"
      
      archivo=$(./reporte_individual.sh "$socio")

      if [[ "$archivo" == "ERROR_SOCIO" || -Z "$archivo" ]]; then
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
          err " No hay teléfono registrado."
        fi

        echo

      done < "$USUARIO_DIR/lista_usuarios.csv"

      sinc_github "Reportes masivos actualizados"

      msg "Todos los reportes fueron generados y enviados."
      pausa
    }

    # Detectar entorno
    if grep -qi "android" /proc/version; then 
      OPEN_URL="termux-open-url"
    elif 
      grep -qi "microsft" /proc/version; then 
      OPEN_URL="wslview"
    else 
      OPEN_URL="xdg-open"
    fi 

    enviar_whatsapp_link() {
      tel="$1"
      mensaje="$2"
      url="https://wa.me/52$tel?text=$mensaje"
      msg "Abriendo WhatsApp Web..."
      $OPEN_URL "$url"
      
    }

  probar_conexion_whatsapp() {
    titulo "Abriendo WhatsApp Web..."
    sleep 1
    $OPEN_URL "https://wa.me/528996750548?text=Prueba%20de%20conexion"
  }

clear
titulo "Envío por WhatsApp"
item_menu "1" "Enviar mensaje individual"
item_menu "2" "Enviar reporte a todo los socios"
item_menu "3" "Provar conexion"
item_menu "0" "Cancelar"
read -r -p "Selecione una opcion (1/2/3/0)" opt
linea_simple
cancelar_si_solicita "$opt" || return 0 

case "opt" in 
  1) enviar_reporte_individual ;;
  2) enviar_reporte_todos ;;
  3) probar_conexion_whatsapp ;;
  0) return ;;
  *) msg "Opción inválida."; sleep 1 ;;
esac 



