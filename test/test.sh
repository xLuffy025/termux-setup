  #!/usr/bin/env bash

read -p "Nombre de la Nota: " nota 

mkdir -p "~/nota"

dir="~/nota"
filename="$dir/$nota.md"
title="$nota"

echo "# $title" > "$filename"

nvim "$filename"
