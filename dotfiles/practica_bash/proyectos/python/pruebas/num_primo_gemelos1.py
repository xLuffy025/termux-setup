import numpy as np

def primos_gemelos_numpy(limite, mostrar=False):
    sieve = np.ones(limite+1, dtype=bool)
    sieve[:2] = False
    for i in range(2, int(limite**0.5)+1):
        if sieve[i]:
            sieve[i*i:limite+1:i] = False
    primos = np.nonzero(sieve)[0]
    contador = 0
    for i in range(len(primos)-1):
        if primos[i+1] - primos[i] == 2:
            contador += 1
            if mostrar:
                print(f"Primos gemelos: {primos[i]} y {primos[i+1]}")
    return contador

# Ejemplo
print("Total pares:", primos_gemelos_numpy(10000000))
