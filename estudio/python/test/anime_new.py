import feedparser
import subprocess
import os

# Ruta para guardar el ID de la última noticia vista
LOG_FILE = "/data/data/com.termux/files/home/ultima_noticia.txt"

def enviar_notificacion(titulo, link):
    subprocess.run([
        "termux-notification",
        "-t", "Crunchyroll ⛩️",
        "-c", titulo,
        "--action", f"termux-open {link}"
    ])

def check_anime_news():
    try:
        url = "https://www.crunchyroll.com/news"
        feed = feedparser.parse(url)

        if not feed.entries:
            print("No se encontraron noticias en el feed.")
            return

        # Obtenemos la más reciente
        ultima_entrada = feed.entries[0]
        titulo = ultima_entrada.title
        link = ultima_entrada.link
        noticia_id = ultima_entrada.id # El ID único de la noticia

        # Leer cuál fue la última que enviamos
        if os.path.exists(LOG_FILE):
            with open(LOG_FILE, "r") as f:
                ultima_leida = f.read().strip()
        else:
            ultima_leida = ""

        # Solo notificar si es nueva
        if noticia_id != ultima_leida:
            enviar_notificacion(titulo, link)
            # Guardar el nuevo ID
            with open(LOG_FILE, "w") as f:
                f.write(noticia_id)
        else:
            print("Sin noticias nuevas por ahora.")

    except Exception as e:
        # Si falla el internet o algo, opcionalmente podrías enviarte una 
        # notificación de error o simplemente dejar un log.
        print(f"Error: {e}")

if __name__ == "__main__":
    check_anime_news()
