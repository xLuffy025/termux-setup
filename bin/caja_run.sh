#!/usr/bin/env bash
set -euo pipefail

### ================================
### CONFIGURACIÓN DE SEGURIDAD
### ================================

USUARIO_AUTORIZADO="xLuffy025"

DISPOSITIVOS_PERMITIDOS=(
  "Tablet"
  "Moto"
  "Archpc"
  "Archwsl"
)

HASH_PASSWORD="f531e3449f06360047c0b4835997753c4716dd207d02e01edee0dfd0b5ad0d68  -"

REMOTE="onedrive:/caja_2026"
LOCAL="$HOME/caja_2026"
LOCK_FILE=".caja.lock"
CAJA_OWNER="xLuffy025"
MAX_INTENTOS=3
TMP_DIR="$HOME/.cache/caja"


mkdir -p "$TMP_DIR"



### ================================
### FUNCIONES
### ================================

DEVICE_ID_FILE="$HOME/.caja_device_id"

if [[ ! -f "$DEVICE_ID_FILE" ]]; then
  echo "⛔ Device ID no configurado"
  echo "Crea el archivo con:"
  echo "  echo \"phone1\" > ~/.caja_device_id"
  exit 1
fi

DEVICE_ID="$(cat "$DEVICE_ID_FILE" | tr -d '\n')"

[[ -n "$DEVICE_ID" ]] || {
  echo "⛔ Device ID vacío"
  exit 1
}

notify() {
  if command -v termux-notification >/dev/null; then
    termux-notification --title "🏦 Caja 2026" --content "$1"
  else
    echo "[Caja] $1"
  fi
}

backup_caja() {
  FECHA="$(date +%F_%H-%M)"
  DESTINO="crypt_caja:/cierre/$FECHA"

  notify "📦 Creando respaldo completo..."
  rclone copy "$LOCAL" "$DESTINO"

  notify "✅ Respaldo creado correctamente"
}

limpiar_backups() {
  BASE="onedrive:/caja_2026_respaldo/cierre"

  notify "🧹 Limpiando respaldos antiguos..."
  rclone lsf "$BASE" | sort | head -n -30 | while read -r old; do
    rclone purge "$BASE/$old"
  done
}

log_backup() {
  echo "$(date '+%F %T') | backup | device=$DEVICE_ID" >> "$HOME/.caja_backup.log"
}

abort() {
  notify "⛔ $1"
  echo "ERROR: $1"
  exit 1
}

### ================================
### VALIDACIONES
### ================================

intentos=0
AUTENTICADO=false
LOG_FILE="$HOME/.caja_access.log"

while [[ $intentos -lt $MAX_INTENTOS ]]; do
  clear
  echo "=============================="
  echo " 🏦  CAJA 2026 - ACCESO"
  echo "=============================="
  echo

  read -p "Usuario: " USER_INPUT
  read -s -p "Contraseña: " PASS
  echo
  echo

  if [[ "$USER_INPUT" != "$CAJA_OWNER" ]]; then
    echo "⛔ Usuario incorrecto"
    echo "$(date '+%F %T') | usuario incorrecto | device=$DEVICE_ID" >> "$LOG_FILE"
  else
    if echo -n "$PASS" | sha256sum | grep -qx "$HASH_PASSWORD"; then
      AUTENTICADO=true
      break
    else
      echo "⛔ Contraseña incorrecta"
      echo "$(date '+%F %T') | contraseña incorrecta | device=$DEVICE_ID" >> "$LOG_FILE"
    fi
  fi

  intentos=$((intentos + 1))
  echo
  echo "Intento $intentos de $MAX_INTENTOS"
  sleep 2
done

if [[ "$AUTENTICADO" != true ]]; then
  notify "⛔ Acceso bloqueado (demasiados intentos)"
  echo "$(date '+%F %T') | acceso bloqueado | device=$DEVICE_ID" >> "$LOG_FILE"
  echo "Acceso bloqueado. Inténtalo más tarde."
  exit 1
fi

### ================================
### BLOQUEO REMOTO
### ================================

notify "🔍 Verificando bloqueo remoto..."

if rclone lsf "$REMOTE" | grep -qx "$LOCK_FILE"; then
  echo "Caja en uso por:"
  rclone cat "$REMOTE/$LOCK_FILE"
  abort "Caja ya está en uso"
fi


echo "$CAJA_OWNER | $DEVICE_ID | $(date '+%F %T')" > "$TMP_DIR/$LOCK_FILE"
rclone copyto "$TMP_DIR/$LOCK_FILE" "$REMOTE/$LOCK_FILE"

### ================================
### SINCRONIZAR ↓
### ================================

notify "📥 Sincronizando desde la nube..."
mkdir -p "$LOCAL"
rclone sync "$REMOTE" "$LOCAL"

cd "$LOCAL"
chmod +x caja.sh

### ================================
### EJECUTAR SISTEMA
### ================================

notify "▶️ Caja iniciada en  $DEVICE_ID"
./caja.sh

### ================================
### BACKUP + SUBIR ↑
### ================================

notify "📦 Creando respaldo..."
rclone sync "$LOCAL" "$REMOTE"

### ================================
### LIBERAR BLOQUEO
### ================================
backup_caja
log_backup
limpiar_backups

rclone deletefile "$REMOTE/$LOCK_FILE"
rm -f "$TMP_DIR/$LOCK_FILE"

notify "✅ Caja cerrada y sincronizada correctamente"
