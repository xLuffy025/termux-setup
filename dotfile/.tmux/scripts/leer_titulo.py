import json
with open("/data/data/com.termux/files/home/cancion_actual.json") as f:
    data = json.load(f)
    print(data["titulo"])
