#!/bin/bash

# Función para verificar si un número es primo
es_primo() {
    num=$1
    if [ $num -lt 2 ]; then
        return 1
    fi
    for ((i=2; i*i<=num; i++)); do
        if (( num % i == 0 )); then
            return 1
        fi
    done
    return 0
}

# Límite
limite=100

# Buscar primos gemelos
for ((n=2; n<=limite; n++)); do
    if es_primo $n && es_primo $((n+2)); then
        echo "Primos gemelos: $n y $((n+2))"
    fi
done
