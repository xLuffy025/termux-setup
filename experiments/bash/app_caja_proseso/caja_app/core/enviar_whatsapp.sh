#!/usr/bin/env bash
set -euo pipefail

while true; do 
  clear 

  enviar_reporte_individual() {
    clear 
    titulo "Enviar reporte individual"

    cut -d',' -f1 "$USUARIO_DIR/lista_usuario.csv"

    read -r -p "Nombre corto del socio" socio

    [[ "$socio" == "0" ]] && return 

    tel=$(grep "^$socio," "$USUARIO_DIR/lista_usuario.csv" | cut -d',' -f4)

    if [[ -z "$tel" ]]; then
      err "No se encontró telélefono para $socio"
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
    git pull
    git add .
    git commit -m "Reporte actualizado para $socio" </dev/null 2>%1
    git push >/dec/null 2>&1

    nombre_archivo=$(basename "$archivo")
    link"https://xluffy025.github.io/caja-2026-reportes/reportes/$nombre_archivo"

    mensaje="Hola $socio, aqui esta tu estado de cuenta: $link"
    enviar_whatsapp_link "$tel" "$mensaje"

    cd - >/dev/null 2>&1

    enviar_reporte_todos() {
      clear 
      titulo "Enviar reporte a todos los Socios"
      confirmar 

      REPO=~/caja-2026-reportes 
      mkdir -p "$REPO/reportes"



    }

    }
  }
