#!/data/data/com.termux/files/usr/bin/bash

MODE=$(printf "
💼 work     ▸ Enfoque y productividad
🧘 relax    ▸ Paz y música suave
🌙 night    ▸ Silencio y tonos oscuros
❤️ date     ▸ Ambiente romántico
🔄 normal   ▸ Configuración estándar
" | fzf --height=10 --reverse --prompt="Selecciona tu modo: " --preview="echo {}" --preview-window=up:3)

MODE_NAME=$(echo "$MODE" | awk '{print $2}')
ICON=$(echo "$MODE" | awk '{print $1}')

echo "$MODE_NAME" > ~/.tmux_mode

# Aplicar colores directamente
case $MODE_NAME in
  work)
    BG="colour235"; FG="colour45"; MSG="💼 Modo Trabajo — Enfocado y listo para código."
    ;;
  relax)
    BG="colour24";  FG="colour87"; MSG="🧘 Modo Relax — Respira y deja que fluya."
    ;;
  night)
    BG="colour234"; FG="colour250"; MSG="🌙 Modo Noche — Silencio, sombra y concentración."
    ;;
  date)
    BG="colour52";  FG="colour217"; MSG="❤️ Modo Cita — Que tu terminal te enamore."
    ;;
  normal)
    BG="colour235"; FG="colour136"; MSG="🔄 Modo Normal — Todo bajo control."
    ;;
esac

tmux set -g status-bg "$BG"
tmux set -g status-fg "$FG"
tmux display-message "$MSG"
