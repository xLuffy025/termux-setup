#!/bin/bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/config.sh"


SOCIO="$1"

if [[ -z "$SOCIO" ]]; then
    echo "Debes indicar un socio. Ejemplo: ./reporte_individual.sh juan_01"
    exit 1
fi


CSV=$(REGISTROS_CSV "$SOCIO")
LISTA="$LISTA_USUARIOS"
DIR="$REPORTES_DIR/$SOCIO"
mkdir -p "$DIR"

FECHA=$(date +"%d-%m-%Y_%H-%M-%S")
OUT="$DIR/reporte_${SOCIO}_${FECHA}.html"

# Validar socio
if ! grep -E "^$SOCIO," "$LISTA" >/dev/null 2>&1; then
    echo "El socio '$SOCIO' no existe."
    exit 1
fi

# Obtener fecha de entrega y contraseña
FECHA_ENTREGA=$(grep "^$SOCIO," "$LISTA" | cut -d',' -f2)
CLAVE=$(grep "^$SOCIO," "$LISTA" | cut -d',' -f3)

# Validar CSV
if [[ ! -s "$CSV" ]]; then
    TOTAL="0.00"
    APORTES=0
    ULTIMA="N/A"
else
    TOTAL=$(awk -F',' '{s+=$3} END{printf "%.2f",s}' "$CSV")
    APORTES=$(awk -F',' 'END{print NR}' "$CSV")
    ULTIMA=$(tail -n 1 "$CSV" | cut -d',' -f1)
fi

MINIMO=50
MAXIMO=5000

# Validar cumplimiento
CUMPLE="si"

while IFS=',' read -r fecha _ monto evidencia; do
    # Si alguna aportación es menor al mínimo
    if (( $(echo "$monto < $MINIMO" | bc -l) )); then
        CUMPLE="no"
    fi

    # Si alguna aportación es mayor al máximo
    if (( $(echo "$monto > $MAXIMO" | bc -l) )); then
        CUMPLE="no"
    fi
done < "$CSV"

if [[ "$CUMPLE" == "si" ]]; then
    BADGE="<span class='badge-ok'>Al día</span>"
else
    BADGE="<span class='badge-late'>Fuera de rango</span>"
fi


# Generar HTML
{
echo "<html><head><meta charset='UTF-8'><title>Reporte de $SOCIO</title>"
echo "<style>

/* ======== ESTILO CHADRACULA‑ENVONDEV ======== */

body {
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #1e1f29;
    color: #f8f8f2;
    padding: 20px;
}

/* Títulos */
h1, h2 {
    color: #50fa7b;
    text-shadow: 0 0 8px #50fa7b;
    text-align: center;
}

/* Texto pequeño */
small {
    color: #8be9fd;
}

/* Contenedor de login */
#login {
    background: #282a36;
    padding: 25px;
    border-radius: 12px;
    width: 80%;
    margin: auto;
    box-shadow: 0 0 15px #6272a4;
}

/* Input */
input[type='password'] {
    background: #44475a;
    border: 1px solid #6272a4;
    color: #f8f8f2;
    padding: 10px;
    border-radius: 6px;
    width: 60%;
}

/* Botón */
button {
    background: #bd93f9;
    border: none;
    padding: 10px 20px;
    color: #1e1f29;
    font-weight: bold;
    border-radius: 6px;
    cursor: pointer;
    margin-top: 10px;
    box-shadow: 0 0 10px #bd93f9;
}

button:hover {
    background: #ff79c6;
    box-shadow: 0 0 12px #ff79c6;
}

/* Tabla */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 25px;
    background: #282a36;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 0 15px #6272a4;
}

th {
    background: #44475a;
    color: #50fa7b;
    padding: 12px;
    text-shadow: 0 0 6px #50fa7b;
}

td {
    padding: 10px;
    border-bottom: 1px solid #6272a4;
}

tr:hover {
    background: #3a3c4e;
}

/* Enlaces */
a {
    color: #8be9fd;
    text-decoration: none;
    font-weight: bold;
}

a:hover {
    color: #ff79c6;
    text-shadow: 0 0 6px #ff79c6;
}

/* Badges */
.badge-ok {
    background: #50fa7b;
    color: #1e1f29;
    padding: 6px 12px;
    border-radius: 8px;
    font-weight: bold;
    box-shadow: 0 0 10px #50fa7b;
}

.badge-late {
    background: #ff5555;
    color: #1e1f29;
    padding: 6px 12px;
    border-radius: 8px;
    font-weight: bold;
    box-shadow: 0 0 10px #ff5555;
}

/* Imagen del encabezado */
.logo {
    display: block;
    margin: 0 auto 20px auto;
    width: 180px;
    border-radius: 12px;
    border: 2px solid #bd93f9;
    box-shadow: 0 0 15px #bd93f9;
}

</style>"

echo "</head><body>"

echo "<div id='login' style='text-align:center; margin-top:50px;'>
<h2>Reporte protegido</h2>
<p>Ingresa tu clave personal</p>
<input type='password' id='pass' placeholder='Contraseña' style='padding:8px; font-size:16px;'>
<button onclick='checkPass()' style='padding:8px 16px; font-size:16px;'>Entrar</button>
</div>"

echo "<div id='contenido' style='display:none;'>"
echo "<img src='https://img.freepik.com/vector-premium/caja-ahorros-monedas_773186-1394.jpg' class='logo'>" 
echo "<h1>Estado de cuenta: $SOCIO</h1>"
echo "<small>Generado: $(date +'%d-%m-%Y %H:%M')</small><br>"
echo "<small>Fecha de entrega: $FECHA_ENTREGA</small><br>"
echo "<small>Aportes: $APORTES — Total: $TOTAL</small><br>"
echo "$BADGE<br><br>"

# Tabla
echo "<table><thead><tr><th>Fecha</th><th>Monto</th><th>Evidencia</th></tr></thead><tbody>"

if [[ -s "$CSV" ]]; then
    while IFS=',' read -r fecha _ monto evidencia; do

        # Si es link, mostrarlo como enlace clicable
        if [[ "$evidencia" =~ ^https?:// ]]; then
            link="<a href='$evidencia' target='_blank'>Ver imagen</a>"
        else
            link="$evidencia"
        fi

        echo "<tr><td>$fecha</td><td>$monto</td><td>$link</td></tr>"
    done < "$CSV"
fi

echo "</tbody><tfoot><tr><td>Total</td><td colspan=2>$TOTAL</td></tr></tfoot></table>"
echo "</div>"

# Script de contraseña
echo "<script>
const CLAVE_HASH = '$CLAVE';

async function checkPass() {
    const claveIngresada = document.getElementById('pass').value.trim();
    if (!claveIngresada) return;

    const hashBuffer = await crypto.subtle.digest(
        'SHA-256',
        new TextEncoder().encode(claveIngresada)
    );

    const hashHex = Array.from(new Uint8Array(hashBuffer))
        .map(b => b.toString(16).padStart(2, '0'))
        .join('');

    if (hashHex === CLAVE_HASH) {
        document.getElementById('login').style.display = 'none';
        document.getElementById('contenido').style.display = 'block';
    } else {
        alert('❌ Clave incorrecta');
    }
}
</script>"

echo "</body></html>"
} > "$OUT"

echo "$OUT"


