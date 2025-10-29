const https = require("https");
const querystring = require("querystring");

// Reemplaza con tus datos
const client_id = "32bc493fe9254b358a0550085e59224e";
const client_secret = "0ffeae7b54d04b54a4f561e66c5e4bea";
const refresh_token = "AQDsYWutVhiXnjV1xpWhcoRsVz1NDvwqtCs0DUMqTVGMpg3sd96MkzR5tgGMr1acKAvAa_4rymGE9CEYHc78dnNkLPYxFLE-JrTEQteBGZJiScCM8f7NQZ4L2mqGDspkrIg";

// Paso 1: Obtener nuevo Access Token
const data = querystring.stringify({
  grant_type: "refresh_token",
  refresh_token,
  client_id,
  client_secret,
});

const tokenOptions = {
  hostname: "accounts.spotify.com",
  path: "/api/token",
  method: "POST",
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    "Content-Length": data.length,
  },
};

const tokenReq = https.request(tokenOptions, tokenRes => {
  let body = "";
  tokenRes.on("data", chunk => (body += chunk));
  tokenRes.on("end", () => {
    const tokenData = JSON.parse(body);
    const access_token = tokenData.access_token;

    // Paso 2: Obtener canción actual
    const songOptions = {
      hostname: "api.spotify.com",
      path: "/v1/me/player/currently-playing",
      method: "GET",
      headers: {
        Authorization: `Bearer ${access_token}`,
      },
    };

    const songReq = https.request(songOptions, songRes => {
      let songBody = "";
      songRes.on("data", chunk => (songBody += chunk));
      songRes.on("end", () => {
        try {
          const song = JSON.parse(songBody);
          if (song && song.item) {
            const title = song.item.name;
            const artist = song.item.artists.map(a => a.name).join(", ");
            console.log(`🎵 ${title} - ${artist}`);
          } else {
            console.log("🎵 Nada sonando");
          }
        } catch {
          console.log("🎵 Error al leer Spotify");
        }
      });
    });

    songReq.end();
  });
});

tokenReq.write(data);
tokenReq.end();

