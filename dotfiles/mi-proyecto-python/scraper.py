#!/data/data/com.termux/files/usr/bin/python

import requests
from bs4 import BeautifulSoup
import subprocess

def revisar_noticias():
    url = "https://elpais.com"
    respuesta = requests.get(url, timeout=10)

    if respuesta.status_code == 200:
        soup = BeautifulSoup(respuesta.text, 'html.parser')
        titulares = soup.find_all('h2', limit=5)

        texto = "📰 Últimas noticias:\n"
        for i, t in enumerate(titulares):
            texto += f"{i+1}. {t.text.strip()}\n"

    else:
        texto = "❌ Error al acceder a El País"

    # Enviar notificación
    subprocess.run([
        "termux-notification",
        "--title", "Noticias",
        "--content", texto[:1000],  # límite de Android
        "--priority", "high"
    ])

if __name__ == "__main__":
    revisar_noticias()

