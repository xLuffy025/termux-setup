import datetime as dt
import time
import os

def to_bin(n, bits):
    # Tu lógica original para convertir y reemplazar por emojis
    return bin(n)[2:].zfill(bits).replace("1", "🟩").replace("0", "⬛")

try:
    while True:
        # 1. Limpiar la pantalla (Funciona en Termux y Linux)
        os.system('clear') 
        
        # 2. Obtener la hora actual dentro del bucle
        now = dt.datetime.now()
        h, m, s = now.hour, now.minute, now.second
        
        # 3. Imprimir el reloj
        print("🕒 BINARY EMOJI CLOCK\n")
        print(f"HOUR ({h:02}) :", to_bin(h, 5)) # 5 bits para Hora (0-23)
        print(f"MIN  ({m:02}) :", to_bin(m, 6)) # 6 bits para Minutos (0-59)
        print(f"SEC  ({s:02}) :", to_bin(s, 6)) # 6 bits para Segundos (0-59)
        
        # 4. Esperar 1 segundo antes de actualizar
        time.sleep(1)

except KeyboardInterrupt:
    # Esto permite salir limpiamente con Ctrl + C
    print("\n\nReloj detenido. 👋")
