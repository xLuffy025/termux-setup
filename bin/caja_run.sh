#!/usr/bin/env bash
set -euo pipefail

### ================================
### CONFIGURACIÓN DE SEGURIDAD
### ================================

USUARIO_AUTORIZADO="JoseDimas"

DISPOSITIVOS_PERMITIDOS=(
  "Tablet"
  "Moto"
  "Archpc"
  "Archwsl"
)

HASH_PASSWORD="f531e3449f06360047c0b4835997753c4716dd207d02e01edee0dfd0b5ad0d68  -"

REMOTE="onedrive:/caja_2026"
REMOTE_BACKUPS="onedrive:/caja_2026_backups"
LOCAL="$HOME/caja_2026"
LOCK_FILE=".caja.lock"
CAJA_OWNER="JoseDimas"
TMP_DIR="$HOME/.cache/caja"

mkdir -p "$TMP_DIR"



### ================================
### FUNCIONES
### ================================

notify() {
  if command -v termux-notification >/dev/null; then
    termux-notification --title "🏦 Caja 2026" --content "$1"
  else
    echo "[Caja] $1"
  fi
}

abort() {
  notify "⛔ $1"
  echo "ERROR: $1"
  exit 1
}

### ================================
### VALIDACIONES
### ================================

# Usuario
[[ "$CAJA_OWNER" == "$USUARIO_AUTORIZADO" ]] || abort "Usuario no autorizado"

# Dispositivo

DEVICE_ID_FILE="$HOME/.caja_device_id"

[[ -f "$DEVICE_ID_FILE" ]] || abort "Device ID no configurado"

DEVICE_ID="$(cat "$DEVICE_ID_FILE")"

printf '%s\n' "${DISPOSITIVOS_PERMITIDOS[@]}" | grep -qx "$DEVICE_ID" \
  || abort "Dispositivo no autorizado: $DEVICE_ID"

# Contraseña
read -s -p "Contraseña de Caja 2026: " PASS
echo
echo -n "$PASS" | sha256sum | grep -qx "$HASH_PASSWORD" \
  || abort "Contraseña incorrecta"

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
rclone sync "$LOCAL" "$REMOTE" \
  --backup-dir "$REMOTE_BACKUPS/$(date +%F_%H-%M)"

### ================================
### LIBERAR BLOQUEO
### ================================

rclone deletefile "$REMOTE/$LOCK_FILE"
rm -f "$TMP_DIR/$LOCK_FILE"

notify "✅ Caja cerrada y sincronizada correctamente"
