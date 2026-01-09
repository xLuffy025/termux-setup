#!/data/data/com.termux/files/usr/bin/bash
set -e

REMOTE="onedrive:/caja_2026"
LOCAL="$HOME/caja_2026"

termux-notification --title "Caja 2026" --content "🔄 Sincronizando desde la nube..."

# 📥 Descargar versión más reciente
rclone sync "$REMOTE" "$LOCAL"

cd "$LOCAL"

chmod +x caja.sh

termux-notification --title "Caja 2026" --content "▶️ Ejecutando sistema..."

./caja.sh

termux-notification --title "Caja 2026" --content "⏫ Subiendo cambios..."

# 📤 Subir cambios al cerrar
rclone sync "$LOCAL" "$REMOTE"

termux-notification --title "Caja 2026" --content "✅ Sincronización completa"
