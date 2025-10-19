# Nivel 3: [Usuarios, Grupos y Seguridad en Linux]

Este nivel se enfoca en la gestion de usuarios, grupos y 
la seguridad básica del sistema.
Apenderás a crear modificar y auditar cuentas, entender los archivos claves 
del sistema y aplicar buenas practicas de administración 

## 🧠 Conceptos clave
1. Usuarios              
* Cada usuario tiene un UID (User ID) único.
* Se definen en el archivo */etc/passwd.*
* Tiene un directorio personal *(/home/usuario)* y una shell asignada

2. Grupos
* Permiten organizar usuarios con permisos compartidos
* Se definen en /etc/group.
* Un usuario puede permanecer en varios grupos.

3. archivoas Importantes

|     archivo    |   Descripcion             |
|:-------------: | :------------------------:|
|  /etc/passwd   | Lista de usuarios y sus   |
|                |  datos básicos            |
|                |                           |
|  /etc/shadow   | Contraseña cifrada        |
|                |                           |
|  /etc/group    | Lista de grupos           |
|                |                           |
|  /etc/gshadow  | Contrasña de  grupos      |
|                |                           |
| /etc/login.defs| Politicas de login (edad  |
|                | de contraseñas, UID       |
|                |   minimos, etc)           |
|--------------------------------------------|



#
## 🧭 Comandos importantes
- `comando`: descripción
- `comando`: descripción

## 🔧 Ejemplos prácticos
```bash
# Comando de ejemplo:-
ls -l

