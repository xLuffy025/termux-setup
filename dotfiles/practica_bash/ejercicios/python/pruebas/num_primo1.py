def es_primo(n):
    if n < 2:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

limite = 10000000
for n in range(2, limite+1):
    if es_primo(n) and es_primo(n+2):
        print(f"Primos gemelos: {n} y {n+2}")
