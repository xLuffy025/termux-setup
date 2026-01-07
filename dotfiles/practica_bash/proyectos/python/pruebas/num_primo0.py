def criba_eratostenes(N):
    """Devuelve una lista booleana donde indice i indica si i es primo."""
    es_primo = [True] * (N + 1)
    es_primo[0:2] = [False, False]          # 0 y 1 no son primos
    for p in range(2, int(N**0.5) + 1):
        if es_primo[p]:
            for múltiplo in range(p * p, N + 1, p):
                es_primo[múltiplo] = False
    return es_primo

def primos_gemelos_hasta(N):
    es_primo = criba_eratostenes(N)
    gemelos = []
    for p in range(2, N - 1):
        if es_primo[p] and es_primo[p + 2]:
            gemelos.append((p, p + 2))
    return gemelos

# Ejemplo: todas las parejas de primos gemelos ≤ 200
print(primos_gemelos_hasta(200))
