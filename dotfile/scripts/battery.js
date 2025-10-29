const { exec } = require("child_process");

exec("termux-battery-status", (err, stdout) => {
  if (err) {
    console.error("Error:", err);
    return;
  }

  try {
    const data = JSON.parse(stdout);
    const percent = data.percentage;
    const status = data.status === "CHARGING" ? "⚡" : "🔋";
    console.log(`${status} ${percent}%`);
  } catch (e) {
    console.error("Parse error:", e);
  }
});
