#!/bin/bash
# caja.sh - Control de caja por socio, exportando CSV/HTML/PDF

set -euo pipefail

DATA_DIR="data"
REPORT_DIR="reports"
MINIMO=50
MAXIMO=1000

mkdir -p "$DATA_DIR" "$REPORT_DIR"

usage() {
  echo "Uso:"
  echo "  $0 registro <Socio>           # Registrar aportación para Socio"
  echo "  $0 reporte <Socio>            # Generar HTML y PDF de estado de cuenta de Socio"
  echo "  $0 reporte-todos              # Generar reportes para todos los CSV en data/"
  echo "  $0 listar                      # Listar socios registrados"
}

valid_name() {
  # Permite letras, números, guiones y espacios; evita path traversal
  echo "$1" | grep -E '^[A-Za-z0-9 _-]+$' >/dev/null
}

archivo_socio() {
  local socio="$1"
  echo "$DATA_DIR/${socio}.csv"
}

registro() {
  local socio="$1"
  if ! valid_name "$socio"; then
    echo "Nombre inválido. Usa letras/números/espacios/guiones."
    exit 1
  fi
  local file
  file=$(archivo_socio "$socio")
  touch "$file"

  echo "Monto aportado:"
  read -r monto
  if ! echo "$monto" | grep -E '^[0-9]+(\.[0-9]{1,2})?$' >/dev/null; then
    echo "Monto inválido. Usa números (ej. 500 o 500.00)."
    exit 1
  fi
  if (( $(echo "$monto < $MINIMO" | bc -l) )); then
    echo "Error: monto menor al mínimo ($MINIMO)."
    exit 1
  fi
  if (( $(echo "$monto > $MAXIMO" | bc -l) )); then
    echo "Error: monto mayor al máximo ($MAXIMO)."
    exit 1
  fi

  echo "Ruta o link de evidencia (ej. foto.jpg o URL de OneDrive):"
  read -r evidencia

  fecha=$(date +"%Y-%m-%d")
  # CSV: fecha,socio,monto,evidencia
  echo "$fecha,$socio,$monto,$evidencia" >> "$file"
  echo "✅ Aportación registrada en $file"
}

html_header() {
  cat <<'EOF'
<!doctype html>
<html lang="es">
<meta charset="utf-8">
<title>Estado de cuenta</title>
<style>
body{font-family:system-ui,Segoe UI,Arial;margin:24px;}
h1{margin:0 0 8px;}
small{color:#666;}
table{border-collapse:collapse;width:100%;margin-top:16px;}
th,td{border:1px solid #ddd;padding:8px;text-align:left;}
th{background:#f4f6f8;}
tfoot td{font-weight:bold;}
.badge{display:inline-block;padding:2px 8px;border-radius:12px;font-size:12px;}
.badge-ok{background:#e7f7e7;color:#146c2e;border:1px solid #bfe3bf;}
.badge-late{background:#fdecea;color:#8a1c1c;border:1px solid #f5c6c6;}
</style>
EOF
}

generate_html() {
  local socio="$1"
  local csv="$DATA_DIR/${socio}.csv"
  local out="$REPORT_DIR/${socio}.html"
  if [ ! -s "$csv" ]; then
    echo "Sin datos para $socio ($csv)."
    return 1
  fi

  total=$(awk -F',' '{s+=$3} END{printf "%.2f",s}' "$csv")
  aportes=$(awk -F',' 'END{print NR}' "$csv")

  # Cumplimiento: suma >= (registros * mínimo)
  cumple=$(awk -F',' -v min="$MINIMO" '{c++; s+=$3} END{if(s>=c*min)print "si";else print "no"}' "$csv")
  badge='<span class="badge badge-ok">Al día</span>'
  [ "$cumple" = "no" ] && badge='<span class="badge badge-late">Atrasado</span>'

  {
    html_header
    echo "<h1>Estado de cuenta: $socio</h1>"
    echo "<small>Generado: $(date +"%Y-%m-%d %H:%M")</small><br>"
    echo "<small>Min: $MINIMO · Max: $MAXIMO · Aportes: $aportes · Total: $total</small><br>"
    echo "$badge"
    echo "<table><thead><tr><th>Fecha</th><th>Monto</th><th>Evidencia</th></tr></thead><tbody>"
    awk -F',' '{
      # fecha,$2=socio,$3=monto,$4=evidencia
      ev=$4
      if (ev ~ /^https?:\/\//) { link="<a href=\"" ev "\" target=\"_blank\">Evidencia</a>" }
      else { link=ev }
      printf "<tr><td>%s</td><td>$ %0.2f</td><td>%s</td></tr>\n", $1, $3, link
    }' "$csv"
    echo "</tbody><tfoot><tr><td>Total</td><td colspan=2>$ $total</td></tr></tfoot></table>"
    echo "</html>"
  } > "$out"
  echo "🧾 HTML: $out"
}

render_pdf() {
  local socio="$1"
  local html="$REPORT_DIR/${socio}.html"
  local pdf="$REPORT_DIR/${socio}.pdf"
  if [ ! -f "$html" ]; then
    echo "No existe HTML para $socio. Genera primero: $0 reporte $socio"
    return 1
  fi
  python3 render_pdf.py "$html" "$pdf"
  echo "📄 PDF: $pdf"
}

reporte() {
  local socio="$1"
  generate_html "$socio" && render_pdf "$socio"
}

reporte_todos() {
  for f in "$DATA_DIR"/*.csv; do
    [ -e "$f" ] || { echo "No hay CSVs en $DATA_DIR"; return; }
    socio=$(basename "$f" .csv)
    generate_html "$socio" || true
    render_pdf "$socio" || true
  done
}

listar() {
  for f in "$DATA_DIR"/*.csv; do
    [ -e "$f" ] || { echo "Sin registros aún."; return; }
    echo "$(basename "$f" .csv)"
  done
}

# CLI
cmd="${1:-}"
case "${cmd}" in
  registro)
    [ $# -ge 2 ] || { usage; exit 1; }
    registro "$2"
    ;;
  reporte)
    [ $# -ge 2 ] || { usage; exit 1; }
    reporte "$2"
    ;;
  reporte-todos)
    reporte_todos
    ;;
  listar)
    listar
    ;;
  *)
    usage
    ;;
esac
