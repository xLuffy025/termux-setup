const fs = require("fs");

const meminfo = fs.readFileSync("/proc/meminfo", "utf8");
const total = parseInt(meminfo.match(/MemTotal:\s+(\d+)/)[1]);
const free = parseInt(meminfo.match(/MemAvailable:\s+(\d+)/)[1]);
const used = total - free;
const percent = Math.round((used / total) * 100);

console.log(`🧠 RAM: ${percent}%`);
