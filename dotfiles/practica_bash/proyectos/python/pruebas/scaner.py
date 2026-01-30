#!/usr/bin/env python
import nmap

# Crear el objeto escáner
scanner = nmap.PortScanner()

# Pedir la IP al usuario
ip = input("Inserte una dirección IP: ")
print("Estás en la IP que escribiste:", ip)

# Escanear la IP (puedes especificar puertos si quieres)
scanner.scan(ip, '1-1024')

# Mostrar los hosts encontrados
print("Hosts encontrados:", scanner.all_hosts())

# Ejemplo: mostrar información de cada host
for host in scanner.all_hosts():
    print("Host:", host)
    print("Estado:", scanner[host].state())
    for proto in scanner[host].all_protocols():
        print("Protocolo:", proto)
        ports = scanner[host][proto].keys()
        for port in ports:
            print("Puerto:", port, "Estado:", scanner[host][proto][port]['state'])


