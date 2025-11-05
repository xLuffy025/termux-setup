const express = require("express");
const open = require("open");
const https = require("https");
const querystring = require("querystring");

const client_id = "32bc493fe9254b358a0550085e59224e";
const client_secret = "0ffeae7b54d04b54a4f561e66c5e4bea";
const redirect_uri = "http://127.0.0.1:8888/callback";

const app = express();

app.get("/callback", (req, res) => {
  const code = req.query.code;

  const data = querystring.stringify({
    grant_type: "authorization_code",
    code,
    redirect_uri,
    client_id,
    client_secret,
  });

  const options = {
    hostname: "accounts.spotify.com",
    path: "/api/token",
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-Length": data.length,
    },
  };

  const tokenReq = https.request(options, tokenRes => {
    let body = "";
    tokenRes.on("data", chunk => (body += chunk));
    tokenRes.on("end", () => {
      const tokens = JSON.parse(body);
      res.send("¡Autenticación completada! Puedes cerrar esta pestaña.");
      console.log("Access Token:", tokens.access_token);
      console.log("Refresh Token:", tokens.refresh_token);
    });
  });

  tokenReq.write(data);
  tokenReq.end();
});

app.listen(8888, () => {
  const scopes = "user-read-currently-playing";
  const authURL = `https://accounts.spotify.com/authorize?${querystring.stringify({
    response_type: "code",
    client_id,
    scope: scopes,
    redirect_uri,
  })}`;

  console.log("Abre esta URL en tu navegador para autorizar:");
  console.log(authURL);
  });
