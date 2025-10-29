#!/data/data/com.termux/files/usr/bin/bash

echo "Selecciona tu modo:"
echo "1) 💼 Trabajo"
echo "2) 🧘 Relax"
echo "3) 🌙 Noche"
echo "4) ❤️ Cita"
echo "5) 🔄 Normal"
read -p "Opción: " choice

case $choice in
  1) MODE="work"; BG="colour235"; FG="colour45"; ICON="💼" ;;
  2) MODE="relax"; BG="colour24";  FG="colour87"; ICON="🧘" ;;
  3) MODE="night"; BG="colour234"; FG="colour250"; ICON="🌙" ;;
  4) MODE="date";  BG="colour52";  FG="colour217"; ICON="❤️" ;;
  5) MODE="normal";BG="colour235"; FG="colour136"; ICON="🔄" ;;
  *) echo "Opción inválida"; exit 1 ;;
esac

echo "$MODE" > ~/.tmux_mode

# Aplicar colores directamente
tmux set -g status-bg "$BG"
tmux set -g status-fg "$FG"

# Mensaje visual
tmux display-message "$ICON Modo $MODE activado ✅"
