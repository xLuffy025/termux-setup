import time
import resource
import numpy as np

def criba_lista(limite):
    sieve = [True] * (limite + 1)
    sieve[0:2] = [False, False]
    for i in range(2, int(limite**0.5) + 1):
        if sieve[i]:
            for j in range(i*i, limite + 1, i):
                sieve[j] = False
    primos = [i for i, es in enumerate(sieve) if es]
    return primos

def criba_numpy(limite):
    sieve = np.ones(limite + 1, dtype=bool)
    sieve[:2] = False
    for i in range(2, int(limite**0.5) + 1):
        if sieve[i]:
            sieve[i*i:limite+1:i] = False
    return np.nonzero(sieve)[0]

def contar_gemelos(primos, mostrar=False):
    contador = 0
    for i in range(len(primos) - 1):
        if primos[i+1] - primos[i] == 2:
            contador += 1
            if mostrar:
                print(f"Primos gemelos: {primos[i]} y {primos[i+1]}")
    return contador

def medir(funcion_criba, nombre, limite, mostrar):
    print(f"\n🔍 Ejecutando: {nombre}")
    inicio = time.time()
    primos = funcion_criba(limite)
    total = contar_gemelos(primos, mostrar)
    fin = time.time()
    uso = resource.getrusage(resource.RUSAGE_SELF)
    print(f"✅ Total pares: {total}")
    print(f"⏱️ Tiempo: {fin - inicio:.2f} s")
    print(f"🧠 CPU: {uso.ru_utime:.2f} user, {uso.ru_stime:.2f} system")
    print(f"📦 Memoria máxima: {uso.ru_maxrss} KB")

# Menú interactivo
print("🧪 Comparador de criba: listas vs NumPy")
limite = int(input("🔢 Ingresa el límite superior (ej. 10000000): "))
mostrar = input("📋 ¿Mostrar los pares encontrados? (s/n): ").lower() == 's'

medir(criba_lista, "Criba con listas", limite, mostrar)
medir(criba_numpy, "Criba con NumPy", limite, mostrar)
