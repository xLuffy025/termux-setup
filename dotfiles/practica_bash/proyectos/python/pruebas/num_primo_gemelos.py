import time
import resource

def es_primo(n):
    if n < 2:
        return False
    for i in range(2, int(n**0.5)+1):
        if n % i == 0:
            return False
    return True

def primos_gemelos_basico(limite, mostrar):
    contador = 0
    for n in range(2, limite+1):
        if es_primo(n) and es_primo(n+2):
            contador += 1
            if mostrar:
                print(f"Primos gemelos: {n} y {n+2}")
    return contador

def primos_gemelos_criba(limite, mostrar):
    sieve = [True] * (limite+1)
    sieve[0:2] = [False, False]
    for i in range(2, int(limite**0.5)+1):
        if sieve[i]:
            for j in range(i*i, limite+1, i):
                sieve[j] = False
    primos = [i for i, es in enumerate(sieve) if es]
    contador = 0
    for i in range(len(primos)-1):
        if primos[i+1] - primos[i] == 2:
            contador += 1
            if mostrar:
                print(f"Primos gemelos: {primos[i]} y {primos[i+1]}")
    return contador

def medir_recursos(funcion, limite, mostrar):
    inicio = time.time()
    total = funcion(limite, mostrar)
    fin = time.time()
    uso = resource.getrusage(resource.RUSAGE_SELF)
    print("\n--- Estadísticas ---")
    print(f"Pares encontrados: {total}")
    print(f"Tiempo total: {fin - inicio:.2f} segundos")
    print(f"CPU: {uso.ru_utime:.2f} user, {uso.ru_stime:.2f} system")
    print(f"Memoria máxima: {uso.ru_maxrss} KB")

# Menú interactivo
print("🔢 Buscador de primos gemelos")
limite = int(input("Ingresa el límite superior (ej. 10000000): "))
modo = input("¿Quieres listar los pares? (s/n): ").lower()
opt = input("¿Usar criba de Eratóstenes para mayor velocidad? (s/n): ").lower()

mostrar = modo == 's'
usar_criba = opt == 's'

if usar_criba:
    medir_recursos(primos_gemelos_criba, limite, mostrar)
else:
    medir_recursos(primos_gemelos_basico, limite, mostrar)
