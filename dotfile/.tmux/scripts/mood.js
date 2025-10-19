const fs = require("fs");
const mode = fs.readFileSync("/data/data/com.termux/files/home/.tmux_mode", "utf8").trim();

switch (mode) {
  case "work":
    console.log("💼 Modo Trabajo");
    break;
  case "relax":
    console.log("🧘 Modo Relax");
    break;
  case "night":
    console.log("🌙 Modo Noche");
    break;
  case "date":
    console.log("❤️ Modo Cita");
    break;
  default:
    console.log("🔄 Modo Normal");
}
