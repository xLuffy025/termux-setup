#!/usr/bin/env bash

echo "¿Cual es tu edad?"
read EDAD

if [ $EDAD > 18 ]; then 
  echo "Eres mayor de edad"
else
  echo "Eres menor de edad"
fi 
