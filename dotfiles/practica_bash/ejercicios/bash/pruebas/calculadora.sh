#!/usr/bin/env bash

echo "Ingresa el primer numero:"
read NUM1

echo "Ingresa el Segundo numero:"
read NUM2

echo "Que operación desea reslizar? (+, - , *, /)"

read OPERACION

if [ "$OPERACION" = "+" ]; then 
  RESULTADO=$((NUM1 + NUM2))
elif [ "$OPERACION" = "-" ]; then 
  RESULTADO=$((NUM1 - NUM2))
elif [ "$OPERACION" = "*" ]; then
  RESULTADO=$((NUM1 * NUM2))
elif [ "$OPERACION" = "/" ]; then
  RESULTADO=$((NUM1 / NUM2))
else
  echo "Operación no valida"
  exit 1 
fi 
echo "El resultado de $NUM1 $OPERACION $NUM2 es $RESULTADO"

