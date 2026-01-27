#!/usr/bin/env bash
set -euo pipefail

LOCAL="$HOME/caja_2026"
REMOTE="crypt_caja:/cierre"


echo "=============================="
echo " ♻️  RESTAURAR CAJA 2026"
echo "=============================="
echo

echo "Respaldos disponibles:"
rclone lsd "$REMOTE" | awk '{print $NF}'
echo

read -p "Escribe el nombre EXACTO del respaldo a restaurar: " FECHA
[[ -n "$FECHA" ]] || exit 1

echo
read -p "⚠️ Esto sobrescribirá los datos actuales. ¿Seguro? (si/no): " CONF
[[ "$CONF" == "si" ]] || {
  echo "Cancelado"
  exit 0
}

echo "📥 Restaurando respaldo $FECHA..."
rclone sync "$REMOTE/$FECHA" "$LOCAL"

echo "✅ Restauración completada"
