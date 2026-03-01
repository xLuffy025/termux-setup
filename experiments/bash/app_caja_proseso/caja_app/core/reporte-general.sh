#1!/usr/bin/env bash
set -eou pipefail
IFS=$'\n\t'

# ==========================================
#   FUNCIÓN: GENERAR REPORTE HTML
# ==========================================
escape_html() { 
     local s="$1" 
     s="${s//&/&amp;}" 
     s="${s//</&lt;}" 
     s="${s//>/&gt;}" 
     s="${s//\"/&quot;}" 
     s="${s//\'/&#39;}" 
     echo "$s" 
 } 
 
clear
titulo "Generar Reporte HTML"

fecha_reporte=$(date +"%Y-%m-%d_%H:%M:%S")
archivo="$REPORTES_DIR/reporte_${fecha_reporte}.html"

# Función para escapar caracteres HTML
escape_html() {
    sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'
}

# Escribir encabezado HTML
cat > "$archivo" <<'HTML_HEADER' 
<html><head>
   <meta charset="UTF-8">
    <title>Reporte Caja de Ahorro</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        h1 { color: #333; }
        h2 { color: #333; margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; }
        th, td { border: 1px solid #999; padding: 10px; text-align: center; }
        th { background: #333; color: white; font-weight: bold; }
        .verde { background: #c8f7c5; }
        .rojo { background: #f7c5c5; }
        .azul { background: #c5d8f7; }
    </style>
</head>
<body>
EOF

echo "<h1>Reporte Caja de Ahorro</h1>" >> "$archivo"
echo "<p>Generado el: <b>$fecha_reporte</b></p>" >> "$archivo"

echo "<table>" >> "$archivo"
echo "    <tr>" >> "$archivo"
echo "        <th>Socio</th>" >> "$archivo"
echo "        <th>Fecha de entrega</th>" >> "$archivo"
echo "        <th>Total aportado</th>" >> "$archivo"
echo "        <th>Aportaciones</th>" >> "$archivo"
echo "        <th>Última aportación</th>" >> "$archivo"
echo "    </tr>" >> "$archivo"

total_general=0

while IFS=',' read -r socio fecha_entrega resto || [[ -n "$socio" ]]; do
    # Saltar líneas vacías o encabezados
    [[ -z "$socio" || "$socio" == "socio" ]] && continue

    archivo_socio="$USUARIO_DIR/$socio/registros.csv"

    total_socio=0
    aportaciones=0
    ultima="N/A"

    if [[ -s "$archivo_socio" ]]; then
        while IFS=',' read -r f _ m e || [[ -n "$f" ]]; do
            [[ -z "$f" ]] && continue
            # Validar que m es número válido antes de usar bc
            if [[ "$m" =~ ^[0-9]+(\.[0-9]{2})?$ ]]; then
                total_socio=$(echo "$total_socio + $m" | bc)
                aportaciones=$((aportaciones + 1))
                ultima="$f"
            fi
        done < "$archivo_socio"

        clase="verde"
    else
        clase="rojo"
    fi

    total_general=$(echo "$total_general + $total_socio" | bc)

    # Escapar nombre para evitar inyección HTML
    socio_escaped=$(echo "$socio" | escape_html)

    echo "<tr class='$clase'>" >> "$archivo"
    echo "    <td>$socio_escaped</td>" >> "$archivo"
    echo "    <td class='azul'>$fecha_entrega</td>" >> "$archivo"
    echo "    <td>\$$total_socio</td>" >> "$archivo"
    echo "    <td>$aportaciones</td>" >> "$archivo"
    echo "    <td>$ultima</td>" >> "$archivo"
    echo "</tr>" >> "$archivo"

done < "$USUARIO_DIR/lista_usuarios.csv"

echo "</table>" >> "$archivo"
echo "<h2>Total general del grupo: \$$total_general</h2>" >> "$archivo"

# Cerrar HTML
cat >> "$archivo" << 'EOF'
</body>
</html>
EOF

msg "Reporte generado: $archivo"
sleep 3
