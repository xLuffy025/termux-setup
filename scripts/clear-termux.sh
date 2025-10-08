#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo "🔄 Actualizando repositorios..."
pkg update -y && pkg upgrade -y

echo "🔧 Reparando paquetes (si hace falta)..."
dpkg --configure -a || true
apt --fix-broken install -y || true

echo
echo "🧾 Simulando autoremove (no borra nada):"
apt -s autoremove

read -p "¿Quieres ejecutar ahora 'apt autoremove -y' para eliminar los paquetes mostrados? [y/N] " resp
if [[ "$resp" =~ ^[Yy]$ ]]; then
  apt autoremove -y
else
  echo "Autoremove cancelado por usuario."
fi

echo "🧹 Limpiando caches..."
apt clean
apt autoclean
# pip cache
if command -v pip3 >/dev/null; then
  pip3 cache purge || true
fi
# npm cache
if command -v npm >/dev/null; then
  npm cache clean --force || true
fi

echo "✅ Limpieza completada. Espacio ahora:"
df -h $HOME



