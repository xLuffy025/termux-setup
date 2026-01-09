#!/usr/bin/env bash

# ===== COLORES =====
RESET="\e[0m"
ROJO="\e[31m"
VERDE="\e[32m"
AMARILLO="\e[33m"
AZUL="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BLANCO="\e[97m"

# ==============================
#  CONFIGURACIÓN BÁSICA
# ==============================

DATA_DIR="./datos_tanda"
PARTICIPANTES_CSV="$DATA_DIR/participantes.csv"
PAGOS_CSV="$DATA_DIR/pagos.csv"

# Monto fijo por aportación (puedes cambiarlo)
MONTO_APORTE=100

# ==============================
#  FUNCIONES AUXILIARES
# ==============================

inicializar_archivos() {
    mkdir -p "$DATA_DIR"

    if [[ ! -f "$PARTICIPANTES_CSV" ]]; then
        echo "id,nombre,fecha_cumple,orden,recibio" > "$PARTICIPANTES_CSV"
    fi

    if [[ ! -f "$PAGOS_CSV" ]]; then
        echo "fecha,id_participante,monto,nota" > "$PAGOS_CSV"
    fi
}

pausa() {
    echo
    read -rp "Presiona ENTER para continuar..." _
}

generar_nuevo_id() {
    # Toma el último id del archivo de participantes y suma 1
    if [[ ! -s "$PARTICIPANTES_CSV" || "$(wc -l < "$PARTICIPANTES_CSV")" -le 1 ]]; then
        echo 1
    else
        tail -n +2 "$PARTICIPANTES_CSV" | awk -F',' 'END {print $1+1}'
    fi
}

listar_participantes() {
    echo "====== PARTICIPANTES ======"
    tail -n +2 "$PARTICIPANTES_CSV" | awk -F',' '
    BEGIN { printf "%-5s %-20s %-12s %-5s\n", "ID", "NOMBRE", "CUMPLEAÑOS", "ORD." }
    {
        printf "%-5s %-20s %-12s %-5s\n", $1, $2, $3, $4
    }'
}

quien_sigue() {
    # Buscar al participante con el orden más bajo que aún no recibe
    linea=$(tail -n +2 "$PARTICIPANTES_CSV" | awk -F',' '$5=="no" {print $0}' | sort -t',' -k4,4n | head -n 1)

    if [[ -z "$linea" ]]; then
        echo -e "${VERDE}✔ Todos los participantes ya recibieron su tanda.${RESET}"
        return
    fi

    id=$(echo "$linea" | awk -F',' '{print $1}')
    nombre=$(echo "$linea" | awk -F',' '{print $2}')
    fecha=$(echo "$linea" | awk -F',' '{print $3}')
    orden=$(echo "$linea" | awk -F',' '{print $4}')

    echo -e "${AMARILLO}➡ Le toca a: ${CYAN}${nombre}${RESET}"
    echo -e "${AMARILLO}   ID: ${BLANCO}${id}${RESET}"
    echo -e "${AMARILLO}   Cumpleaños: ${BLANCO}${fecha}${RESET}"
    echo -e "${AMARILLO}   Orden: ${BLANCO}${orden}${RESET}"
}

cancelar_si_solicita() {
  local entrada="$1"
  if [[ "$entrada" == "0" || "$entrada" == "salir" ]]; then
    echo -e "${AMARILLO}Operación cancelada por el usuario.${RESET}"
    pausa
    return 1 
  fi 
  return 0

}
# ==============================
#  ALTAS Y CONFIGURACIÓN
# ==============================

alta_participante() {
  while true; do 
    clear
    echo -e "${CYAN}===============================${RESET}"
    echo -e "${MAGENTA}    Alta de participante    ${RESET}"
    echo -e "${CYAN}===============================${RESET}"

    read -rp "Nombre completo (0 para cancelar) : " nombre
    cancelar_si_solicita "$nombre" || return 
    [[ -z "$nombre" ]] && { echo "Nombre vacío. Cancelando."; pausa; continue; }

    read -rp "Fecha de cumpleaños (DD-MM-YYYY) (0 para cancelar) : " fecha_cumple
    cancelar_si_solicita "$fecha_cumple" || return
    [[ -z "$fecha_cumple" ]] && { echo "Fecha vacía. Cancelando."; pausa; continue; }

    read -rp "Orden en la tanda (0 para cancelar) : " orden
    cancelar_si_solicita "$orden" || return
    [[ -z "$orden" ]] && { echo -e "${ROJO}Orden vacío. Cancelando.${RESET}"; pausa; continue; }
    break 
  done

    id_nuevo=$(generar_nuevo_id)

    echo "${id_nuevo},${nombre},${fecha_cumple},${orden},no" >> "$PARTICIPANTES_CSV"

    echo -e "${VERDE}Participante agregado con ID: ${BLANCO}$id_nuevo ${RESET}"
    pausa
}

# ==============================
#  PAGOS
# ==============================
registrar_pago() {
    echo -e "${CYAN}=== Registrar pago ===${RESET}"
    listar_participantes
    echo

    read -rp "ID del participante que paga (0 para cancelar): " idp
    cancelar_si_solicita "$idp" || return
    [[ -z "$idp" ]] && { echo -e "${ROJO}ID vacío. Cancelando.${RESET}"; pausa; return; }

    if ! grep -q "^${idp}," "$PARTICIPANTES_CSV"; then
        echo -e "${ROJO}No existe participante con ID ${idp}.${RESET}"
        pausa
        return
    fi

    echo
    echo -e "${AMARILLO}¿Para qué socio es este pago?${RESET}"
    listar_participantes
    echo

    read -rp "ID del socio que recibe el pago (0 para cancelar): " id_dest
    cancelar_si_solicita "$id_dest" || return

    if ! grep -q "^${id_dest}," "$PARTICIPANTES_CSV"; then
        echo -e "${ROJO}No existe participante con ID ${id_dest}.${RESET}"
        pausa
        return
    fi

    fecha_hoy=$(date +%Y-%m-%d)

    echo -e "Monto sugerido: ${VERDE}$MONTO_APORTE${RESET}"
    read -rp "Monto a registrar (ENTER para usar $MONTO_APORTE, 0 para cancelar): " monto
    cancelar_si_solicita "$monto" || return
    [[ -z "$monto" ]] && monto="$MONTO_APORTE"

    echo "${fecha_hoy},${idp},${monto},${id_dest}" >> "$PAGOS_CSV"

    echo -e "${VERDE}✔ Pago registrado correctamente.${RESET}"
    pausa
}

# ==============================
#  CONSULTAS
# ==============================

ver_estado_participante() {
    echo "=== Estado de un participante ==="
    listar_participantes
    echo

    read -rp "ID del participante: " idp
    [[ -z "$idp" ]] && { echo "ID vacío. Cancelando."; pausa; return; }

    linea=$(grep "^${idp}," "$PARTICIPANTES_CSV" || true)
    if [[ -z "$linea" ]]; then
        echo "No existe participante con ID ${idp}."
        pausa
        return
    fi

    nombre=$(echo "$linea" | awk -F',' '{print $2}')
    echo
    echo "Participante: $nombre (ID: $idp)"
    echo "Pagos registrados:"
    echo

    # Mostrar pagos
    awk -F',' -v ID="$idp" '
    BEGIN { printf "%-12s %-10s %-20s\n", "FECHA", "MONTO", "ORDEN"}
    NR>1 && $2==ID {
        printf "%-12s %-10s %-20s\n", $1, $3, $4
    }' "$PAGOS_CSV"

    # Total pagado
    total=$(awk -F',' -v ID="$idp" '
    NR>1 && $2==ID {s+=$3} END {print s+0}' "$PAGOS_CSV")

    echo
    echo "Total pagado por $nombre: $total"
    pausa
}


# ==============================
#  RESUMEN GENERAL
# ==============================
ver_resumen_general() {
    echo "=== Resumen general de la tanda ==="
    echo

    # Para cada participante, sumar sus pagos
    tail -n +2 "$PARTICIPANTES_CSV" | while IFS=',' read -r id nombre fecha_cumple orden; do
        total=$(awk -F',' -v ID="$id" '
        NR>1 && $2==ID {s+=$3} END {print s+0}' "$PAGOS_CSV")

        printf "%-5s %-20s %-12s %-5s %-10s\n" "$id" "$nombre" "$fecha_cumple" "$orden" "$total"
    done

    pausa
}

marcar_recibido() {
    echo "=== Marcar como recibido ==="
    listar_participantes
    echo

    read -rp "ID del participante que ya recibió su tanda: " idp
    [[ -z "$idp" ]] && { echo "ID vacío. Cancelando."; pausa; return; }

    if ! grep -q "^${idp}," "$PARTICIPANTES_CSV"; then
        echo "No existe participante con ID ${idp}."
        pausa
        return
    fi

    # Crear archivo temporal
    tmp=$(mktemp)

    awk -F',' -v ID="$idp" 'BEGIN{OFS=","}
    NR==1 {print; next}
    {
        if ($1==ID) {
            $5="si"
        }
        print
    }' "$PARTICIPANTES_CSV" > "$tmp"

    mv "$tmp" "$PARTICIPANTES_CSV"

    echo "Marcado como recibido."
    pausa
}

verificar_pago_cumple() {
    echo -e "${CYAN}=== Verificar pagos del participante que le toca ===${RESET}"

    # Obtener al participante con el orden más bajo que aún no recibe
    linea=$(tail -n +2 "$PARTICIPANTES_CSV" | awk -F',' '$5=="no" {print $0}' | sort -t',' -k4,4n | head -n 1)

    if [[ -z "$linea" ]]; then
        echo -e "${VERDE}✔ Todos los participantes ya recibieron su tanda.${RESET}"
        pausa
        return
    fi

    id=$(echo "$linea" | awk -F',' '{print $1}')
    nombre=$(echo "$linea" | awk -F',' '{print $2}')
    fecha=$(echo "$linea" | awk -F',' '{print $3}')
    orden=$(echo "$linea" | awk -F',' '{print $4}')

    echo -e "${AMARILLO}➡ Le toca a: ${CYAN}${nombre}${RESET}"
    echo -e "${AMARILLO}Cumpleaños: ${BLANCO}${fecha}${RESET}"
    echo -e "${AMARILLO}Orden: ${BLANCO}${orden}${RESET}"
    echo

    # Total de participantes
    total_participantes=$(tail -n +2 "$PARTICIPANTES_CSV" | wc -l)

    # Total esperado (menos el cumpleañero)
    total_esperado=$(( (total_participantes - 1) * MONTO_APORTE ))

    orden_actual=$(echo "$linea" | awk -F',' '{print $4}')

    # Total pagado al cumpleañero 

    total_pagado=$(awk -F',' -v DEST="$id" -v ORDEN="$orden_actual" '
    NR>1 && $4==DEST {
        # Verificamos que el destinatario esté en turno
        print $0
    }
    ' "$PAGOS_CSV" | awk -F',' '{s+=$3} END {print s+0}')
 
    # Barra de progreso
    porcentaje=$(( (100 * total_pagado) / total_esperado ))
    barras=$(( porcentaje / 5 ))  # cada bloques = 5%

    barra=""
    for ((i=0; i<barras; i++)); do barra+="█"; done
    for ((i=barras; i<20; i++)); do barra+="░"; done

    echo -e "${CYAN}Progreso: [${barra}] ${porcentaje}%${RESET}"
    echo

    # Mostrar quién ya pagó y quién falta
    echo -e "${MAGENTA}Pagos individuales:${RESET}"
    echo

    tail -n +2 "$PARTICIPANTES_CSV" | while IFS=',' read -r pid pnombre pcumple porden precibio; do
        if [[ "$pid" == "$id" ]]; then
            continue  # el cumpleañero no paga
        fi

        pago=$(awk -F',' -v ID="$pid" -v DEST="$id" -v ORDEN="$orden_actual" '
            NR>1 && $2==ID && $4==DEST {
                print $0
            }
        ' "$PAGOS_CSV" | awk -F',' '{s+=$3} END {print s+0}')


        if (( pago >= MONTO_APORTE )); then
            echo -e "${VERDE}✔ ${pnombre} pagó${RESET}"
        else
            echo -e "${ROJO}✘ ${pnombre} falta por pagar${RESET}"
        fi
    done

    echo
    echo -e "${BLANCO}Total pagado: ${VERDE}${total_pagado}${RESET}"
    echo -e "${BLANCO}Total esperado: ${AMARILLO}${total_esperado}${RESET}"
    echo

    if (( total_pagado >= total_esperado )); then
        echo -e "${VERDE}✔ YA TIENE TODOS LOS PAGOS${RESET}"
    else
        faltante=$(( total_esperado - total_pagado ))
        echo -e "${ROJO}✘ AÚN FALTAN ${faltante} POR PAGAR${RESET}"
    fi

    pausa
}

# ==============================
#  MENÚ PRINCIPAL
# ==============================

menu_principal() {
    while true; do
        clear
        echo -e "${CYAN}========================================${RESET}"
        echo -e "${MAGENTA}   ADMINISTRACIÓN TANDA DE CUMPLEAÑOS   ${RESET}"
        echo -e "${CYAN}========================================${RESET}"
        echo 

        echo -e "${VERDE}Estado actual:${RESET}"
        quien_sigue
        echo
        echo -e "${AZUL}1)${RESET} Alta de participante"
        echo -e "${AZUL}2)${RESET} Registrar pago"
        echo -e "${AZUL}3)${RESET} Ver estado de un participante"
        echo -e "${AZUL}4)${RESET} Ver resumen general"
        echo -e "${AZUL}5)${RESET} Listar participantes"
        echo -e "${AZUL}6)${RESET} Marcar como recibido"
        echo -e "${AZUL}7)${RESET} Verificar si la persona que le toca ya tiene todos los pagos"
        echo -e "${ROJO}0)${RESET} Salir"
        read -rp "Opción: " op

        case "$op" in
            1) alta_participante ;;
            2) registrar_pago ;;
            3) ver_estado_participante ;;
            4) ver_resumen_general ;;
            5) listar_participantes; pausa ;;
            6) marcar_recibido ;;
            7) verificar_pago_cumple ;;
            0) echo "Saliendo..."; exit 0 ;;
            *) echo "Opción inválida"; pausa ;;
        esac
    done
}

# ==============================
#  INICIO
# ==============================

inicializar_archivos
menu_principal
