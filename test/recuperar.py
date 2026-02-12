import hashlib

# 1. PEGA AQUÍ EL HASH QUE TIENES GUARDADO EN TU REGISTRO
hash_objetivo = "9baed8fceea6e36d36670d72429d909547165efc038c293a14a41ef2edf83141" 

# Lista de contraseñas de prueba comunes
posibles_passwords = [
    "1234", "1973", "2017", "1953", "020693", "1968", "0524", "050918", "alpirez06", "Luna0529",
    "Hanma123@?", "Angel", "1486"
]

def probar_password(password, objetivo):
    # Probamos SIN salto de línea (lo más común en apps)
    hash_limpio = hashlib.sha256(password.encode('utf-8')).hexdigest()
    if hash_limpio == objetivo:
        return f"¡ENCONTRADA! Es: '{password}' (sin salto de línea)"
    
    # Probamos CON salto de línea (común si usaste 'echo' en terminal)
    hash_con_enter = hashlib.sha256((password + "\n").encode('utf-8')).hexdigest()
    if hash_con_enter == objetivo:
        return f"¡ENCONTRADA! Es: '{password}' (pero fue creada con un Enter al final)"
    
    return None

print(f"Buscando hash: {hash_objetivo}...")

encontrada = False
for p in posibles_passwords:
    resultado = probar_password(p, hash_objetivo)
    if resultado:
        print(f"\n✅ {resultado}")
        encontrada = True
        break

if not encontrada:
    print("\n❌ No está en la lista de pruebas comunes.")

