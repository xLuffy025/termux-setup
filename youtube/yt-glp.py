#!/usr/bin/env python3
import os
import yt_dlp
import argparse
import re
import time

# Carpeta base
CARPETA_BASE = "musica_por_categoria"

# --------------------------------------------------
# Limpieza de nombres de archivo (segura)
# --------------------------------------------------
def limpiar_nombre_archivo(nombre):
    nombre = re.sub(r'[<>:"/\\|?*]', '', nombre)
    nombre = re.sub(r'\([^)]*\)|\[[^\]]*\]', '', nombre)
    nombre = re.sub(r'\s+', ' ', nombre)
    nombre = nombre.strip(' -_|.')
    return nombre[:90].strip()

# --------------------------------------------------
# Normalizar URLs problemáticas
# --------------------------------------------------
def normalizar_url(url):
    if "music.youtube.com" in url:
        url = url.replace("music.youtube.com", "www.youtube.com")
    return url.strip()

# --------------------------------------------------
# Descargar contenido
# --------------------------------------------------
def descargar_contenido(url, carpeta_destino, formato="mp3"):
    url = normalizar_url(url)

    if not os.path.exists(carpeta_destino):
        os.makedirs(carpeta_destino)

    if formato == "mp3":
        ydl_opts = {
            "format": "bestaudio[ext=m4a]/bestaudio",
            "outtmpl": os.path.join(
                carpeta_destino,
                "%(uploader|Unknown)s - %(title)s.%(ext)s"
            ),
            "postprocessors": [
                {
                    "key": "FFmpegExtractAudio",
                    "preferredcodec": "mp3",
                    "preferredquality": "192",
                }
            ],
            "noplaylist": True,
            "quiet": False,
            "retries": 5,
            "fragment_retries": 5,
            "http_headers": {
                "User-Agent": "Mozilla/5.0"
            },
        }
    else:  # MP4
        ydl_opts = {
            "format": "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4",
            "outtmpl": os.path.join(
                carpeta_destino,
                "%(uploader|Unknown)s - %(title)s.%(ext)s"
            ),
            "noplaylist": True,
            "quiet": False,
            "retries": 5,
            "fragment_retries": 5,
            "http_headers": {
                "User-Agent": "Mozilla/5.0"
            },
        }

    try:
        print(f"\n⬇️ Descargando ({formato.upper()}): {url}")
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)

        # Buscar archivo final real
        archivos = os.listdir(carpeta_destino)
        archivos_descargados = [
            f for f in archivos
            if f.lower().endswith(f".{formato}")
        ]

        if not archivos_descargados:
            print("⚠️ Archivo vacío o no creado, se omite.")
            return

        archivo = max(
            archivos_descargados,
            key=lambda f: os.path.getmtime(os.path.join(carpeta_destino, f))
        )

        ruta_original = os.path.join(carpeta_destino, archivo)
        nombre_base, ext = os.path.splitext(archivo)

        nombre_limpio = limpiar_nombre_archivo(nombre_base)
        ruta_nueva = os.path.join(carpeta_destino, nombre_limpio + ext)

        if ruta_original != ruta_nueva:
            contador = 1
            ruta_final = ruta_nueva
            while os.path.exists(ruta_final):
                ruta_final = os.path.join(
                    carpeta_destino,
                    f"{nombre_limpio} ({contador}){ext}"
                )
                contador += 1
            os.rename(ruta_original, ruta_final)
            print(f"📝 Renombrado: {os.path.basename(ruta_final)}")

        print("✅ Descarga completada")

    except Exception as e:
        print(f"❌ Error con {url}")
        print(f"   {e}")
        time.sleep(2)

# --------------------------------------------------
# Procesar archivos TXT
# --------------------------------------------------
def procesar_archivo_txt(nombre_txt, formato):
    categoria = os.path.splitext(nombre_txt)[0]
    carpeta_destino = os.path.join(CARPETA_BASE, categoria)

    with open(nombre_txt, "r", encoding="utf-8", errors="ignore") as f:
        urls = [
            line.strip()
            for line in f
            if line.strip().startswith("http")
        ]

    print(f"\n📁 Categoría: {categoria} | Total: {len(urls)}")

    for url in urls:
        descargar_contenido(url, carpeta_destino, formato)

# --------------------------------------------------
# MAIN
# --------------------------------------------------
def main():
    parser = argparse.ArgumentParser(
        description="Descargar música o video por categorías usando TXT"
    )
    parser.add_argument(
        "-f", "--formato",
        choices=["mp3", "mp4"],
        default="mp3",
        help="Formato de descarga"
    )

    args = parser.parse_args()

    if not os.path.exists(CARPETA_BASE):
        os.makedirs(CARPETA_BASE)

    archivos_txt = [f for f in os.listdir() if f.endswith(".txt")]

    if not archivos_txt:
        print("❌ No se encontraron archivos .txt")
        return

    print(f"🎧 Modo: {args.formato.upper()}")

    for archivo in archivos_txt:
        procesar_archivo_txt(archivo, args.formato)

if __name__ == "__main__":
    main()
