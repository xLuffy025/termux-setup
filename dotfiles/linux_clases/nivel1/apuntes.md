# Nivel 1: [Fundamentos de Shell (Completo)]

## Objetivo general
Dominar el entorno de Shell Bash: navegar, manipular archivos, comprender rutas, permisos y usar los comandos mas usados del sistema.

## 1. Que es el shell y bash
- shell: intérprete de comandos que traduce lo que escribes al lenguaje del sistema 
- bash:(bourne Again Shell) es el shell por defecto en la mayoria de sistemas Linux y Termux 


## 🧠 Conceptos clave
- [1] 🧭 Comandos de Navegacion
- [2] 📁 Manejo de archivos y directorios
- [3] 📖 Lectura y visualizacion 

## 🧭 Comandos de navegacion

|     Comando       |        Descripcion               |       Ejemplos          |
| :---------------: | :------------------------------: | :---------------------  |
|       `pwd`       |   Muestra la ruta actual         | pwd /home/usuario/      |
|   `cd carpeta`    |   Cambia de carpeta              | cd Downloads            |
|       `cd ..`     |   Retrocede una carpeta          | cd ..                   |
|       `cd ~`      |   Va al directorio personal      | cd ~ (/home/usr/)       | 
|       `ls`        |   Lista Archivos                  | ls -l                   |
|       `la -a`     |   Incluye archivos ocultos       | ls -la                  |


## 📁 Manejo de archivos y directorios 

|    Comando        |           Descripcion             |           Ejemplos                |
| :---------------: | :-------------------------------: | :-------------------------------: |
|       `touch`     | Crea un archivo vacio             |   touch archivo.txt               |
|       `mkdir`     | Crea una carpeta                  |   mkdir carpeta_nueva             |
|       `echo`      | Imprime texto                     |   echo "Hola Linux"
|        `cp`       | Copia una archivo                 |   cp archivo.txt <destino>        |
|        `mv`       | Mueve o renombra                  |   mv <origen> <destino>           |
|        `rm`       | Elimina archivo                   |   rm archivo.txt                  |
|       `rmdir`     | Elimina una carpeta vacia         |   rm carpera_nueva <vacia>        |
|       `rm -R`     | Elimina una carpeta con contenido |   rm carpeta <carpeta/archivo.txt>|

## 📖 Lectura y visualizacion

|    Comandos       |           Descripcion             |           Ejemplos                |
| :---------------: | :------------------------------:  | :------------------------------:  |
|       `cat`       | Muestra contenido completo        | cat archivo.txt                   |
|      `less`       | Permite leer por paginas          | usa /palabras para buscar         |
|      `head`       | Muestra las primeras 10 lineas    | head -n 5 = primeras 5 lineas     |
|      `tail`       | Muestra las ultimas 10 lineas     | tail -f long.txt sigue un archivo |
|                   |                                   | en tiempo real                    |


