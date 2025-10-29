const fs = require("fs");
const path = "/data/data/com.termux/files/home/.spotify_title";
const width = 30; // ancho visible en la barra
let title = fs.readFileSync(path, "utf8").trim();

if (title.length <= width) {
  console.log(title.padEnd(width));
  return;
}

// Desplazamiento circular
const now = Math.floor(Date.now() / 1000);
const offset = now % title.length;
const scroll = (title + " • ").repeat(2).substring(offset, offset + width);
console.log(scroll);
