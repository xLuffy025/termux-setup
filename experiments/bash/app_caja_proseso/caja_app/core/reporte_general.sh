#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LC_NUMERIC=C

# ==========================================
#   FUNCIÓN: GENERAR REPORTE HTML
# ==========================================
# Requisitos: source config.sh previamente (REPORTES_DIR, USUARIO_DIR, LISTA_USUARIOS)
: "${REPORTES_DIR:?REPORTES_DIR no definido en config.sh}"
: "${USUARIO_DIR:?USUARIO_DIR no definido en config.sh}"
LISTA="${LISTA_USUARIOS:-$USUARIO_DIR/lista_usuarios.csv}"

if [[ ! -r "$LISTA" ]]; then
  printf 'ERROR: no se puede leer %s\n' "$LISTA" >&2
  exit 1
fi

# Limpiar pantalla sólo si es TTY
if [[ -t 1 ]]; then clear; fi
titulo="Generar Reporte HTML"

fecha_reporte=$(date +"%Y-%m-%d-%H-%M")
archivo="$REPORTES_DIR/reporte_${fecha_reporte}.html"

escape_html() {
  local s=${1:-}
  s=${s//&/&amp;}
  s=${s//</&lt;}
  s=${s//>/&gt;}
  s=${s//\"/&quot;}
  s=${s//\'/&#39;}
  printf '%s' "$s"
}

cat > "$archivo" <<'HTML'
<html><head>
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
</head><body>
HTML

printf '<h1>Reporte Caja de Ahorro</h1>\n' >> "$archivo"
printf '<p>Generado el: <b>%s</b></p>\n' "$fecha_reporte" >> "$archivo"

cat >> "$archivo" <<'HTML'
<table>
    <tr>
        <th>Socio</th>
        <th>Fecha de entrega</th>
        <th>Total aportado</th>
        <th>Aportaciones</th>
        <th>Última aportación</th>
    </tr>
HTML

total_general="0.00"

# Leer lista de usuarios (ignora vacías/comentarios)
while IFS=',' read -r socio fecha_entrega _ || [[ -n "${socio:-}" ]]; do
    # saltar vacíos o comentarios
    [[ -z "${socio// /}" || "${socio:0:1}" == "#" ]] && continue

    socio_trimmed="$(echo "$socio" | xargs)"
    archivo_socio="$USUARIO_DIR/$socio_trimmed/registros.csv"

    total_socio="0.00"
    aportaciones=0
    ultima="N/A"
    clase="rojo"

    if [[ -s "$archivo_socio" ]]; then
        # sumar columna monto (se asume columna 3: fecha,socio,monto,evidencia)
        total_socio=$(awk -F',' 'NF && $3 ~ /[0-9]/ {sum += $3} END {printf "%.2f", sum+0}' "$archivo_socio")
        aportaciones=$(awk -F',' 'NF && $3 ~ /[0-9]/ {n++} END {print (n+0)}' "$archivo_socio")
        ultima=$(awk -F',' 'NF {last=$1} END {print (last=="" ? "N/A" : last)}' "$archivo_socio")
        clase="verde"
    fi

    total_general=$(awk -v a="$total_general" -v b="$total_socio" 'BEGIN{printf "%.2f", a + b}')

    s_esc=$(escape_html "$socio_trimmed")
    f_esc=$(escape_html "${fecha_entrega:-N/A}")
    ultima_esc=$(escape_html "$ultima")

    cat >> "$archivo" <<ROW
    <tr class="${clase}">
        <td>${s_esc}</td>
        <td class='azul'>${f_esc}</td>
        <td>${total_socio}</td>
        <td>${aportaciones}</td>
        <td>${ultima_esc}</td>
    </tr>
ROW

done < "$LISTA"

cat >> "$archivo" <<HTML
</table>
<h2>Total general del grupo: ${total_general}</h2>
</body></html>
HTML

# Mensaje final usando la utilidad msg (de utils.sh)
if command -v msg >/dev/null 2>&1; then
  msg "Reporte generado exitosamente:"
fi
printf '\e[1;36m%s\e[0m\n' "$archivo"
# no dormir por defecto (útil para cron/CI
