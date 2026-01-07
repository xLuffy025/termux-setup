#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/env.sh"

[[ "$ENV" != "termux" ]] && {
  echo "❌ Backup solo disponible en Termux"
  exit 1
}

BACKUP_DIR="$HOME/termux-backups"
DATE="$(date +%Y%m%d-%H%M)"
OUT="$BACKUP_DIR/backup-$DATE"

mkdir -p "$OUT"

echo "📦 Iniciando backup de Termux..."
echo "📂 Destino: $OUT"
echo

# ---------------- HOME ----------------
echo "🏠 Backup HOME..."
tar -czf "$OUT/home.tar.gz" -C "$HOME" .
echo "✅ home.tar.gz creado"

# ---------------- PREFIX ----------------
if [[ -n "${PREFIX:-}" && -d "$PREFIX" ]]; then
  echo "📦 Backup PREFIX ($PREFIX)..."
  tar -czf "$OUT/prefix.tar.gz" -C "$PREFIX" .
  echo "✅ prefix.tar.gz creado"
else
  echo "⚠️ PREFIX no válido — se omite"
  touch "$OUT/prefix.SKIPPED"
fi

# ---------------- PKG LIST ----------------
echo "📜 Guardando lista de paquetes..."
if command -v pkg >/dev/null 2>&1; then
  pkg list-installed > "$OUT/pkg-list.txt" || true
  echo "✅ pkg-list.txt creado"
else
  echo "⚠️ pkg no disponible"
  touch "$OUT/pkg-list.SKIPPED"
fi

# ---------------- PROOT DISTRO ----------------
if command -v proot-distro >/dev/null 2>&1; then
  PROOT_DIR="$PREFIX/var/lib/proot-distro"
  if [[ -d "$PROOT_DIR" ]]; then
    echo "📦 Backup proot-distro..."
    tar -czf "$OUT/proot-distro.tar.gz" -C "$PROOT_DIR" .
    echo "✅ proot-distro.tar.gz creado"
  else
    echo "⚠️ No hay distros instaladas"
    touch "$OUT/proot-distro.EMPTY"
  fi
else
  echo "⚠️ proot-distro no instalado"
  touch "$OUT/proot-distro.SKIPPED"
fi

# ---------------- SUMMARY ----------------
echo
echo "📊 RESUMEN BACKUP:"
ls -lh "$OUT"
echo
echo "✅ Backup completado correctamente"



