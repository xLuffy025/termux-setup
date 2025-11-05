const https = require("https");
https.get("https://wttr.in/Reynosa?format=1", res => {
  res.setEncoding("utf8");
  let data = "";
  res.on("data", chunk => data += chunk);
  res.on("end", () => console.log(data.trim()));
});
