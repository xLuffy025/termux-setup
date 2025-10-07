#!/data/data/com.termux/files/usr/bin/bash
# 🧹 Script para limpiar y optimizar Termux

echo "🧽 Limpiando caché y paquetes innecesarios..."

# 1️⃣ Limpiar caché de paquetes de pkg/apt
apt clean
apt autoclean
apt autoremove -y

# 2️⃣ Limpiar caché temporal de Termux
rm -rf $PREFIX/var/cache/*
rm -rf $PREFIX/tmp/*

# 3️⃣ Borrar caché de pip (si usas Python)
if command -v pip &> /dev/null; then
    pip cache purge
fi

# 4️⃣ Borrar caché de npm (si usas Node.js)
if command -v npm &> /dev/null; then
    npm cache clean --force
fi

# 5️⃣ Limpiar logs antiguos (si existen)
find $HOME -type f -name "*.log" -delete

# 6️⃣ Limpiar sesión de proot-distro (sin borrar rootfs)
if [ -d "$PREFIX/var/lib/proot-distro" ]; then
    echo "🧱 Limpiando caché de proot-distro..."
    rm -rf $PREFIX/var/lib/proot-distro/installed-rootfs-cache/*
fi

echo "✅ Termux limpio y optimizado."
