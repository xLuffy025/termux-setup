# Nivel 1: [Configuracion Inicial]

## 1. Shebang
```bash
#!/bin/bash
# o mejor portabilidad:
#!/usr/bin/env bash
```
## 2. Modo ESTRICTO (Recomendado)
```bash
set -euo pipefall
```
- -e Sale si un comando falla
- -u Trata variables no definidas como un error
- -o pipefall: falla si cualquier comando en un pipe falla

## 3. Identación 
- Usa 2 o 4 espacios (ser consistente)
- Nunca mezclar tabs con espacios
```bash
if [[ condition ]]; then 
    echo "texto"
fi
```

## 4. Comentarios
- Explicar el <u>"por que"<u/>, no el <u>"que"<u/>
- Ser concisos pero informativos

-✅ Bueno: Explicar la razón 
```bash
# Elimina logs antiguos para liberar espacios en disco
rm -rf /var/log/app/*.log
```
-❎ Malo: Repetir lo ovio
```bash
# Eliminar archivo
rm -rf /var/log/app/*.logs
```

## 5. Variables

| Tipo | Convención | Exemplo | Uso |
| --------------- | --------------- | --------------- | --------------- |
| Variables locales | snake_case | `mi_variable="valor"` | Variables de script |
| Variables locales en funcion | local snake_case | `local contador=0` | Limita scope |
| Constantes/ENV |  SCREAMING_SNAKE_CASE | `MAX_INTENTOS=3` | Variables de entorno |
| Solo lectura | readonly o declare -r | `readonly CONFIG_DIR="/etc/"` | Inmutables |
| Arrays | snake_case + contexto | `archivos_lsita=()` | |


- ✅ Ejemplo Válidos
```bash 
mi_nombre="Juan"
local contador=0
readonly -r CONFIG_DIR="/etc/app"

# Declaración robusta
variable="${variable:-valor_por_defecto}"
contador="${contador:-0
```
- ❎ Ejemplo a EVITAR

| ❌ Incorrecto | Problema | ✅ Correcto |
| --------------- | --------------- | --------------- |
| `MiVariable=10` | Inconsitente | `mi_variable=10` |
| `1variable="/temp"` | Comienza con número | `variable1="x"` |
| `ruta-archivo="/temp"` | Guión medio | `ruta_archivo="/temp"` |
| `var = valor` | Espacios alrededor de `=` | `var="valor"` |
| `ls="lista"` | Sobrescribe comando | `archivos_lista="lista"` |
| `var$=5` | Caracteres especiales | `var_dolar=5` |

## 🔒 Variables: Siempre Entrecomillar 

### ✅ Correcto 
```bash
echo "$mi_variable"
echo "${mi_vsriable}"
```
### ❎  Incorrecto
```bash
echo $mi_variable # Vulnerable a word splitting y globbing
```

## 🔧 Funciones

**Convención recomendada:** `sanke_case` con verbos descriptivos

| Estilo  | Ejemplo | Usar |
| --------------- | --------------- | --------------- |
| **sanke_case** | `procesar_archivo()` | ✅ Recomendado |
| **kebab-case** | `procesar-archivo()` | ❌ No usar |
| **camelCase** | `procesarArchivo()` | ⚠️ Valido pero menos comun |
| **PascalCase** | `ProcesarArchivo()` | ❌ No usar |
| **MAYUSCULAS** | `PROCESAR_ARCHIVO()` | ❌ Reservar para constantes |

## ✅ **Buenas Practicas**

### Usar verbos para acciones
```bash
ordered list() { ... }
validar_entrada() { ... }
limpiar_log() { ... }
```
### Prefijos para tipos especificos
```bash
es_valor() { ... }          # Booleanas
tiene_permiso() { ... }     # Verificaciones
obtener_nombre() { ... }    # Retornar datos
mostrar_menu() { ... }      # mostrar informativos
```
### Funciones blooleanas Prefijos es_, tiene_ 
```bash
es_numero()     # Intencion clara
```
## 6. Argumento de Funciones
### ✅ Usar "$@" (preservar espacios)
```bash
mi_funcion "$@"
```
### ❌ Usar $* (no preservar espacios)
```bash
mi_funcion $*
```

### ✔️ Validaciones de validar_entrada
```bash 
# Validar al inicio (fail-fast)
validar_parametros() {
  if [[ -z "$1" ]]; then 
    echo "Error: Falta argumento" >&2
  fi 
}
```







