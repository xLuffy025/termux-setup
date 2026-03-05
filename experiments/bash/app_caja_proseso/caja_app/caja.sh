#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

# ==========================================
#   SISTEMA CAJA DE AHORRO 2026
#   Modelo 3 + Sistema 2
#   Autor: xLuffy025
# ==========================================

# ==========================================
# VARIABLES GLOBALES
# ==========================================
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/config.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/utils.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/logs.sh"

# ==========================================
#     DEPENDENCIAS
# ==========================================
command -v bc >/dev/null || {
  echo "Error: bc no está instalado (install bc)"
  exit 1
}

# ==========================================
#   FUNCIÓN: REGISTRAR SOCIO
# ==========================================
crear_socio() {
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/core/crear_socio.sh"
}

# ==========================================
#   FUNCIÓN: REGISTRAR APORTACIÓN
# ==========================================
registrar_aportacion() {
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/core/aportaciones.sh"
}
  
# ==========================================
#   FUNCIÓN: CONSULTAR HISTORIAL
# ==========================================
consultar_historial() {
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/core/consultar.sh"
    
}

# ==========================================
#   FUNCIÓN: GENERAR REPORTE HTML
# ==========================================
generar_reporte() {
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/core/reporte_general.sh"
}

# ==========================================
#   FUNCIÓN: REPORTE INDIVIDUAL 
# ==========================================
generar_reporte_individual() {
  while true; do 
    clear
    titulo "Reporte Individual"

    confirmar_socios 
    

    # -----------------------------------------
    # 2. Seleccionar socio
    # -----------------------------------------
    while true; do 
      echo ""
      read -r -p "Seleccione el numero del socio: " opcion
      cancelar_si_solicita "$opcion" || return 0 

      if [[ ! "$opcion" =~ ^[1-9]+$ ]] || ((opcion > ${#socios[@]})); then 
        err "Error: Selección invalida."
        pausa
        return 0 
      fi 

      socio="${socios[$((opcion -1))]}"
      break 
    done 

    bash core/reporte_individual.sh "$socio"
    pausa
    break 
  done
}

# ==========================================
#   FUNCIÓN: ENVIAR POR WHATSAPP
# ==========================================
enviar_whatsapp() {
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/core/enviar_whatsapp.sh" 
}
#  while true; do 
#    clear
#
#    enviar_reporte_individual() {
#    clear
#    echo "=== ENVIAR REPORTE INDIVIDUAL ==="
#    echo "0) Cancelar"
#
#    cut -d',' -f1 "$USUARIO_DIR/lista_usuarios.csv"
#    
#    read -p "Nombre corto del socio: " socio
#
#    [[ "$socio" == "0" ]] && return
#
#    tel=$(grep "^$socio," "$USUARIO_DIR/lista_usuarios.csv" | cut -d',' -f4)
#
#    if [[ -z "$tel" ]]; then
#        echo "No se encontró teléfono para $socio"
#        sleep 2
#        return
#    fi
#
#    archivo=$(./lib/reporte_individual.sh "$socio")
#
#    if [[ ! -f "$archivo" ]]; then
#      echo -e "${ROJO}❌ Error: el archivo no existe o la ruta es inválida.${RESET}"
#      echo "Ruta recibida: $archivo"
#      sleep 2
#      return
#    fi 
#     
#    if [[ "$archivo" == "ERROR_SOCIO" || -z "$archivo" ]]; then
#        echo "Error al generar el reporte."
#        sleep 2
#        return
#    fi 
#
#    mkdir -p "$REPO_GITHUB_REPORTES"
#
#    if [[ ! -f "$archivo" ]]; then
#      echo -e "${ROJO}❌ Error: el archivo no existe.${RESET}"
#      echo "Ruta recibida: $archivo"
#      return
#    fi
#
#    if [[ ! -d "$REPO_GITHUB_REPORTES" ]]; then
#      echo -e "${ROJO}❌ Error: la carpeta destino no existe.${RESET}"
#      echo "Ruta esperada: $REPO_GITHUB_REPORTES"
#      return
#    fi 
#
#    
#
#    cp "$archivo" "$REPO_GITHUB_REPORTES/"
# 
#    cd "$REPO_GITHUB_REPORTES" || return
#    git pull
#    git add .
#    git commit -m "Reporte actualizado para $socio" >/dev/null 2>&1
#    git push >/dev/null 2>&1
#
#    nombre_archivo=$(basename "$archivo")
#    link="https://xluffy025.github.io/caja-2026-reportes/reportes/$nombre_archivo"

#    mensaje="Hola $socio, aquí está tu estado de cuenta: $link"
#    enviar_whatsapp_link "$tel" "$mensaje"
#
#    cd - >/dev/null 2>&1
#}
#    enviar_reportes_todos() {
#      clear
#      echo "=== ENVIAR REPORTES A TODOS LOS SOCIOS ==="
#      read -p "¿Continuar? (s/n): " resp
#      [[ "$resp" != "s" && "$resp" != "S" ]] && return#
#
#    REPO=~/caja-2026-reportes
#    mkdir -p "$REPO/reportes"
#
#    while IFS=',' read -r socio fecha clave tel resto; do
#      [[ -z "$socio" || "$socio" == "socio" ]] && continue
#      
#      echo "Procesando: $socio"
#      
#      archivo=$(./lib/reporte_individual.sh "$socio")
#
#      if [[ "$archivo" == "ERROR_SOCIO" || -z "$archivo" ]]; then
#        echo "  Error, se omite."
#        continue
#      fi
#
#      cp "$archivo" "$REPO/reportes/"
#
#      nombre_archivo=$(basename "$archivo")
#      link="https://xluffy025.github.io/caja-2026-reportes/reportes/$nombre_archivo"

#      mensaje="Hola $socio, aquí está tu estado de cuenta: $link"
#
#      if [[ -n "$tel" ]]; then
#        enviar_whatsapp_link "$tel" "$mensaje"
#      else
#        echo "  No hay teléfono registrado."
#      fi 
#
#      echo
#
#    done < "$USUARIO_DIR/lista_usuarios.csv"
#
#    cd "$REPO" || return
#    git pull 
#    git add .
#    git commit -m "Reportes masivos actualizados" >/dev/null 2>&1
#    git push >/dev/null 2>&1
#    cd - >/dev/null 2>&1

#    echo "Todos los reportes fueron generados y enviados."
#    read -p "Enter para continuar..."
#}

  # Detectar entorno
#if grep -qi "android" /proc/version; then
#    OPEN_URL="termux-open-url"
#elif grep -qi "microsoft" /proc/version; then
#    OPEN_URL="wslview"
#else
#    OPEN_URL="xdg-open"
#fi

#enviar_whatsapp_link() {
#    tel="$1"
#    mensaje="$2"
#    url="https://wa.me/52$tel?text=$mensaje"
#    echo "Abriendo WhatsApp Web..."
#    $OPEN_URL "$url"
#}
#
#    probar_conexion_whatsapp() {
#      echo -e "${VERDE}Abriendo WhatsApp Web...${RESET}"
#      sleep 1 
#      $OPEN_URL "https://wa.me/528996750648?text=Prueba%20de%20conexion"
#    }
#        clear
#    echo -e "${CYAN}===========================${RESET}"
#    echo -e "${MAGENTA}=== ENVÍO POR WHATSAPP ===${RESET}"
#    echo -e "${CYAN}===========================${RESET}"
#    echo "1) Enviar mensaje individual"
#    echo "2) Enviar reporte a todos los socios"
#    echo "3) Probar conexion"
#    echo -e "${ROJO}(0 para cancelar)${RESET}"
#    read -p "Solicitar una opción: " opcion
#    cancelar_si_solicita "$opcion" || return 0
#
#    case "$opcion" in 
 #     1) enviar_reporte_individual ;;
 #     2) enviar_reportes_todos ;;
 #     3) probar_conexion_whatsapp ;;
 #     0) return;;
 #     *) echo -e "${ROJO}Opción inválida.${RESET}"; sleep 1 ;;
 #   esac
 #    break
 # done
#}

# ==========================================
#   FUNCIÓN: CONFIGURACIÓN
# ==========================================
configuracion() {
    clear
    echo -e "\e[1;37m=== CONFIGURACIÓN ===\e[0m"
    echo "Módulo en construcción..."
    sleep 2
}

# ==========================================
#   MENÚ PRINCIPAL
# ==========================================
while true; do
    clear
    titulo "SISTEMA CAJA DE AHORRO 2026"
    item_menu "1" "Registrar socio"
    item_menu "2" "Registrar aportación"
    item_menu "3" "Consultar historial"
    item_menu "4" "Generar reporte del periodo"
    item_menu "5" "Generar reporte individual"
    item_menu "6" "Enviar reporte por WhatsApp"
    item_menu "7" "Configuración"
    item_menu "0" "Salir"
    linea_simple
    read -p "Seleccione una opción: " opcion

    case "$opcion" in
        1) crear_socio ;;
        2) registrar_aportacion ;;
        3) consultar_historial ;;
        4) generar_reporte ;;
        5) generar_reporte_individual;;
        6) enviar_whatsapp ;;
        7) configuracion ;;
        0) exit ;;
        *) err "Opción inválida."; sleep 1 ;;
    esac
done


