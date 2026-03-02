#1!/usr/bin/env bash
set -eou pipefail
IFS=$'\n\t'

# ==========================================
#   FUNCIÓN: GENERAR REPORTE HTML
# ==========================================
# ==========================================
    clear
    echo -e "\e[1;32m=== GENERAR REPORTE HTML ===\e[0m"

    fecha_reporte=$(date +"%Y-%m-%d_%H:%M:%S")
    archivo="$REPORTES_DIR/reporte_${fecha_reporte}.html"

    echo "<html><head>
    <meta charset='UTF-8'>
    <title>Reporte Caja de Ahorro</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; padding: 20px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #999; padding: 8px; text-align: center; }
        th { background: #333; color: white; }
        .verde { background: #c8f7c5; }
        .rojo { background: #f7c5c5; }
        .azul { background: #c5d8f7; }
    </style>
    </head><body>" > "$archivo"

    echo "<h1>Reporte Caja de Ahorro</h1>" >> "$archivo"
    echo "<p>Generado el: <b>$fecha_reporte</b></p>" >> "$archivo"

    echo "<table>
        <tr>
            <th>Socio</th>
            <th>Fecha de entrega</th>
            <th>Total aportado</th>
            <th>Aportaciones</th>
            <th>Última aportación</th>
        </tr>" >> "$archivo"

    total_general=0

    while IFS=',' read -r socio fecha_entrega resto; do
        archivo_socio="$USUARIO_DIR/$socio/registros.csv"

        aportaciones=0
        ultima="N/A"

        if [[ -s "$archivo_socio" ]]; then
            while IFS=',' read -r f m e; do
                total_socio=$(echo "$total_socio + $m" | bc)
                aportaciones=$((aportaciones + 1))
                ultima="$f"
            done < "$archivo_socio"

            clase="verde"
        else
            clase="rojo"
        fi

        total_general=$(echo "$total_general + $total_socio" | bc)

        echo "<tr class='$clase'>
                <td>$socio</td>
                <td class='azul'>$fecha_entrega</td>
                <td>$total_socio</td>
                <td>$aportaciones</td>
                <td>$ultima</td>
              </tr>" >> "$archivo"

    done < "$USUARIO_DIR/lista_usuarios.csv"

    echo "</table>" >> "$archivo"

    echo "<h2>Total general del grupo: $total_general</h2>" >> "$archivo"

    echo "</body></html>" >> "$archivo"

    echo -e "\e[1;32mReporte generado exitosamente:\e[0m"
    echo -e "\e[1;36m$archivo\e[0m"
    sleep 3
