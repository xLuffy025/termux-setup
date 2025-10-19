# Nivel 1: Funciones de linux

##  1. **Estructura de directorios**

-   /home: Carpeta personal de cada usuarios
-     /etc: Configuracion del sistema
-     /var: Archivos variables (log,cache)
-     /bin: Comandos esenciales
-     /usr: Programas y Librerias de usuario

##   2. **Comandos basicos de navegacion**                           ## Ejemplos

-      pwd: Muestra el directorio actual                | pwd
-       ls: Lista archivos                              | ls -l ls -la etc 
-       cd: Cambia directorio                           | cd ~/Linux_clases/nivel1
-    mkdir: Crea carpeta                                | mkdir proyectos
-    touch: Crea archivo vacio                          | touch notas.txt
-       rm: Elimina archivos                            | rm notas.txt
-       cp: Copia archivos                              | cp archivo.txt copia.txt
-       mv: Mueve o renombra                            | mv copia.txt final.txt 

##  3. **Permiso y  usuario**

-   whoami: Muestra tu usuario                          | whoami = u0_a270
-       id: Muestra UID y grupos                        | id = uid=10270(u0_a270) gid=10270(u0_a270)
-    chmod: Cambia permisos                             | chmod +x scrip.sh 
-    chown: Cambia propietario                          | sudo chown jose archivo.txt:
