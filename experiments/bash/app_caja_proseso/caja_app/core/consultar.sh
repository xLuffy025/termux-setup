#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
  
# ==========================================
#   FUNCIÓN: CONSULTAR HISTORIAL
# ==========================================
titulo "CONSULTAR HISTORIAL DE UN SOCIO"

# -----------------------------------------
# 1. Verificar si hay socios registrados
# -----------------------------------------
confirmar_socios || return 0

while true; do
  echo ""
  read -r -p "Seleccione el número del socio: " opcion
  cancelar_si_solicita "$opcion" || return 0 

  if [[ ! "$opcion" =~ ^[1-9]+$ ]] || ((opcion > ${#socios[@]})); then
    err "Error: Selección inválida."
    pausa
    return 0 
  fi 

  socio="${socios[$((opcion -1))]}"
  break 
done
 
archivo="$USUARIO_DIR/$socio/registros.csv"

# -----------------------------------------
# 3. Validar si tiene registros
# -----------------------------------------
if [[ ! -s "$archivo" ]]; then
  warn "El socio '$socio' no tiene aportaciones registradas."
  sleep 3
  return 
fi

# -----------------------------------------
# 4. Mostrar historial
# -----------------------------------------
echo ""
titulo "Historial de aportaciones de: $socio"

total=0
contador=0
ultima_fecha="N/A"

while IFS=',' read -r fecha _ monto evidencia; do 
  mostrar_datos "Fecha:" "$fecha"
  mostrar_datos "Monto:" "$monto"
  mostrar_datos "Evidencia:" "$evidencia"
  linea_simple

  total=$(echo "$total + $monto" | bc)
  contador=$((contador + 1))
  ultima_fecha="$fecha" 
done < "$archivo"

# -----------------------------------------
# 5. Resumen final
# -----------------------------------------
echo ""
mostrar_datos "Resumen del socio:" "$socio"
mostrar_datos "Total aportado:" "$total"
mostrar_datos "Número de aportaciones:" "$contador"
mostrar_datos "Última aportación:" "$ultima_fecha"

echo ""
pausa
