# Nivel 2: [Gestión del sistema y procesos]

## 🧠 Conceptos clave
- [4] 🔍 busqueda de archivos y texto 

## 🔍 Busqueda de archivos avanzado y texto

|   Comando        |               Descripcion                  | 
| :--------------: | :----------------------------------------: |
|      `find`      |  Busca archivo por nombre, tipo, fecha    |
|     `locate`     |  Busca rápido usando base de datos        |
|      `grep`      |  Busca texto dentro de archivo            |


## 1 -  Buscar archivos:

- localiza archivo especificos por nombre


|         Comandos            |      Descripción                      |
| :------------------------:  | :-----------------------------------: |
| find . -name "archivo.txt"  | Nombre exacto, sencibles a mayusculas |
| find . -iname "archivo.txt" | Igual pero sin distinguir mayusculas  |
| find . -name "*.sh"         | Archivos con extencion                |

##
- Buscar por tipo 

|   Tipo     |      Significado      |
| :--------: | :-------------------: |
| -type f    | Archivo               |
| -type d    | Directorio            |
| -type l    | Enlaces simbólicos    |

- ejemplos: find . -type f -name "*.log" >> encuenta archivos de log, registros etc.
##
- busca archivos por tamaño
 
|  Simbolo   |       Significa      |
| :--------: | :-----------------:  |
|   +        | Mayor que            |
|   -        | Menor que            |
|(sin signo) | Exactamente igual    |
##
- Y las unidades pueden ser:

|  unidad   |       Significa      |
| :--------: | :----------------:  |
|   c        | bytes               |
|   k        | kilobytes           |
|   M        | megabyte            |
|   G        | gigabytes           |
 (vacio) bloques de 512 bytes (no recomendado)
- ejemplo: find / -size +10M   find . -size -100kill
##
- Buscar por usuario o grupo 
find /home -user juan
find /var/log -group adm
find / -uid 1000
##
- Buscar por Permisos
find . -perm 644
find / -perm -111        # Archivos ejecutables
find / -perm /222        # Tiene permisos de escritura
##
- Buscar por fecha y tiempo

|   Opcion  |       Significado        |
| :-------: | :---------------------:  |
| -mtime    | Dias desde modificacion  |
| -mmin     | Minutos                  |
|   +       | Mas de                   |
|   -       | Menos de                 |

- Ejemplos: 
find /var/log -mtime -1      # Modificados en las últimas 24h
find . -mmin -10             # Modificados en los últimos 10 min
##

## 📌 Ejecutar acciones sobre los hallazgos-

```bash
- Elimina archivos encontrados  
find . -name "*.tmp" -exec rm -f {} \;

- Mover y copiar
find . -name "*.log" -exec mv {} /backup/ \;

- Imprimir detalles
find . -type f -exec ls -lh {} \;

- Buscar y preguntar antes de borrar 
find . -name "*.tmp" -ok rm {} \;

- Buscar archivos vacios 
find . -empty

- Buscar enlaces rotos
find . -xtype l 

- Buscar por patron con regex
find . -regex ".*\.log"
```

- `ps`              : Lista procesos activos
- `top / htop`      : Monitor en tiempo real 
- `kill`            : Termina procesos
- `nice / renice`   : Ajusta prioridad
- `>`               : Redirige salida de un archivo 
- `>>`              : Añade al final de un archivo
- `<`               : Usa archivo como entrada 
- `|`               : Conecta salida con un comando a otro
- `tar`             : Empaqueta archivos 
- `gzip, gunzip`    : Comprime y descomprime
- `zip, unzip`      : altenativa común 



