const { exec } = require("child_process");
exec("pgrep -a mpv", (err, stdout) => {
  if (err || !stdout) return console.log("🎵 Nada");
  const match = stdout.match(/mpv\s+(.*)/);
  console.log(match ? `🎵 ${match[1].slice(0, 30)}` : "🎵 Reproduciendo");
});

