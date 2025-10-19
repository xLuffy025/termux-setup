# Nivel 2: [Gestión del sistema y procesos]

## 🧠 Conceptos clave
- [1] 🔍 Procesos y rendimiento
- [2] 🔄 Redirección y pipes
- [3] 🔎 Búsqueda avansada
- [4] 📦 Compresión y empaquetado

## 🧭 Comandos importantes
- `ps`              : Lista procesos activos
- `top / htop`      : Monitor en tiempo real 
- `kill`            : Termina procesos
- `nice / renice`   : Ajusta prioridad
- `>`               : Redirige salida de un archivo 
- `>>`              : Añade al final de un archivo
- `<`               : Usa archivo como entrada 
- `|`               : Conecta salida con un comando a otro
- `grep`            : Busca texto dentro de archivo
- `find`            : Busca archivo por nombre, tipo, fecha 
- `locate`          : Busca rápido usando base de datos
- `tar`             : Empaqueta archivos 
- `gzip, gunzip`    : Comprime y descomprime
- `zip, unzip`      : altenativa común 



## 🔧 Ejemplos prácticos
```bash
# Comando de ejemplo
## Procesos y rendimiento
ps aux
top 
htop

## Redirección y pipes
echo "Hola Jose" > saludo.txt 
cat saludo.txt >> historial.txt

## Buscar contenido
grep "Hola Jose" historial.txt
find ~/linux_clases -name "*.md"

## Empaquetar y comprimir 
tar -cvf nivel2.tar ~/linux_clases/nivel2 == Empaqueta
tar -xvf nivel2.tar ~/linux_clases/nivel2 == Desempaquetar
gzip nivel2.tar == Comprimir 
gunzip nivel2.tar == Descomprimir



