#! /bin/bash 

echo "actualizando Termux y paquetes..."
pkg update -y && pkg upgrade -y

echo "Limpiando la caché de paquetes..."
pkg clean --all

echo "Eliminando paquetes huérfanos..."
pkg autoclean -y && apt autoremove -y

echo "Limpieza y actualización completada."
