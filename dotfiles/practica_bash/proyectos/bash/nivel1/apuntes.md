# Nivel 1: [Configuracion Inicial]

## 1. Shebang
`#!/bin/bash`
### o mejor portabilidad:
`#!/usr/bin/env bash`

## 2. Modo ESTRICTO (Recomendado)
`set -euo pipefall`
### -e Sale si un comando falla
### -u Trata variables no definidas como un error
### -o pipefall: falla si cualquier comando en un pipe falla

## 3. Identación 
- Usa 2 o 4 espacios (ser consistente)
- Nunca mezclar tabs con espacios

`if [[ condition ]]; then 
    echo "texto"
fi`
 


## 🧠 Conceptos clave


|    Comandos       |           Descripcion             |           Ejemplos                |
| :---------------: | :------------------------------:  | :------------------------------:  |
|       `cat`       | Muestra contenido completo        | cat archivo.txt                   |
|      `less`       | Permite leer por paginas          | usa /palabras para buscar         |
|      `head`       | Muestra las primeras 10 lineas    | head -n 5 = primeras 5 lineas     |
|      `tail`       | Muestra las ultimas 10 lineas     | tail -f long.txt sigue un archivo |
|                   |                                   | en tiempo real                    |


