# Nivel 1: [Configuracion Inicial]

## 1. Shebang
```bash
#!/bin/bash
# o mejor portabilidad:
#!/usr/bin/env bash
```
## 2. Modo ESTRICTO (Recomendado)
```bash
set -euo pipefail
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
- Explicar el <mark>"por que"</mark>, no el <mark>"que"</mark>
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
#### ✅ Usar "$@" (preservar espacios)
```bash
mi_funcion "$@"
```
#### ❌ Usar $* (no preservar espacios)
```bash
mi_funcion $*
```

#### ✔️ Validaciones de validar_entrada
```bash 
# Validar al inicio (fail-fast)
validar_parametros() {
  if [[ -z "$1" ]]; then 
    echo "Error: Falta argumento" >&2
  fi 
}
```
# 🎯 Funciones Puras
- Retornar vía `echo`, no modificar variables globales
- Sin efectos secundarios cuando sea posible

```bash 
# ✅ Función Pura 
obtener_usuario() {
  local usuario="Juan"
  echo "$usuario"
}

resultado=$(obtener_usuario)
```
### ❌ Qué Evitar 
```bash
# ❌ Muy largo
calcular_el_promedio_de_los_numeros() { ... }

# ❌ Muy corto
calc() { ... }

# ❌ Conflicto con comando de sistemas
test() { ... }
echo() { ... }

# Nunca poner el mismo nombre de una variable a una funcinón 

# ✅ Mejor 
test_conexion() { ... }
mostrar_mensaje() { ... }
```
## 🏷️ Nombre de scripts
```bash
# Minusculas, descriptivos, con guiones
# ✅ Correcto
backup-datebase.sh 
procesar-archivos.sh 

# ❌ Evitar 
backupDatebase.sh 
procesar_archivos.sh 

```
## 🔍 Comparaciones Modernas
```bash
# ✅ U4sar [[ ]] (más robusto)
if [[ $var = "valor" ]]; then
  echo "correcto"
fi 

# ❌ Mal Evitar [ ] (menos robusto)
if [ $var = "valor" ]; then 
  echo "antiguo"
fi 

# ✅ solo para operaciones numericas 
if  (( var == "valor" )); then 
  echo "correcto"
fi
```
## 📤 Salida! formateada
```bash
# ✅ printf (más portable y predecible)
printf "%s/n" "$variable"
printf "Usuario: %s, ID: %d/n" "$usuario" "$id"

# echo -e "texto\n"

```
📤
## 🔁 Sustitución de Comandos
```bash
# ✅ Usar $() (fácil de anidar)
archivos=$(ls *.txt)
fecha=$(date +%Y-%m-%d)

# ❌ Evitar backticks (dificil de anidar)
archivos=`ls *.txt`
```

# Qué Evitar
## ⚠️ Antiparametros Comunes

| ❌ Mala Práctica | Por qué evitarlo | ✅ Alternariva |
| --------------- | --------------- | --------------- |
| `echo $variable` | word splitting y globbing | `echo "$variable"` |
| `funcion $*` | No perservar espacios | `funcion "$@"` |
| `cat archivo \| grep patron` | Proceso innecesario (UUOC) | `grep patron archivo` |
| `if [ $var = "x" ]` | Menos robusto | `if [[ $var == "x" ]]` |
| `var=`comando` ` | Dificil de anidar | `var=$(comando)` |
| `echo -e "lineal\n"` | No portable | `printf "linea\n"` |
| `eval $comando` | Riesgo de seguridad | Evitar o sanitizar |
| `comando_critico` (sin verificar) | Script  continúa tras fallo | `comando_critico \|\| exit 1` |
| `contador=$contador+1` | Variable sin inicializar | `contador=${contador:-0}` |
| `function nombre()` | Sintaxis mixta | `nombre()` |
| `[[ "$str" -eq 5 ]]` | `-eq` es para números | `[[ "$srt" == "5" ]]` |
| `cmd \| cmd2 \| cmd3` | Solo verifica último exit code | `set -o pipefail` |

# 🚫 Nunca Hacer 
```bash
# ❌ variable sin comillas en contextos sensibles
rm -rf $firectorio/*

# ❌ Usar eval con entrada no sanitizada
eval $entrada_usuario

# ❌ Ignorar códigos de salida de comandos críticos 
comando_importante
# conrinuar sin verificar...

# ❌ Parsear salida de ls 
for archivo in $(ls); do 
  # problemas con espacios
done

# ✅ Mejor usar globbing 
for archivo in *; do 
  [[ -f "$archivo" ]] && echo "$archivo"
done 


```
## Status Code 

| Código    | Descripción     |
|--------------- | --------------- |
| 0   | ✅ Éxit: comando/función terminó correctament.    |
| 1   | ❌ Error general (no especificado).   |
| 2   | Mal uso de funciones integradas del shell (ej. sintaxis incorrecta)   |
| 126   | Permisos insuficiente para ejecutar el comando   |
| 127   | Comando no encontrado (ej. tipo en el nombre).    |
| 128+n  | Terminación por señal `n` (ej.`130 = 128 + 2` → `SIGINT` / Control+C). |
| 255   | Valor fuera de rango (mayor que 255). |

## Comilllas Dobles y Simples

| **Caracteristica** | `"` **Dobles** | `'` **Simples** |
| --------------- | --------------- | --------------- |
| Expansión de variable | ✅ si - `"$var"` → valor de la variable | ❌ No - `'$var'` → literal `$var`  |
| Sudtitución de comandos  | ✅ si - `"$(date)"` → fecha actual  | ❌ No - `'$(date)'` → literal `$(date)`|
| Expanción del historial (`!cmd`) | ✅ si (si está habilitada con `set -H`)  | ❌ No |
| Caracteres especiales (`*`,`?`,`{}`)  | ✅ Si, si no están escapados | ❌ No, se improme tal cual enviando el globbing y concatenar  | 
| Incluir comillas dentro  | Si, podemos poner `'` sin escapar  | ❌ No podemos poner `'` directamente sin cerrar |
| Globbing (`*`, `?`) | 🔹 Prevenidos si están dentro, salvo que se expandan por `eval` | 🔹 Igual, prevenidos |
| Word splitting (especios) | ✅ Espacios preservados | ✅ Espacios preservados |
