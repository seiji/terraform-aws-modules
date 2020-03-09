const consola = require('consola')
const express = require('express')
const fs = require('fs');
const app = express()

var socketPath = '/tmp/express.sock';

if (process.env.SOCKET_PATH) {
  socketPath = process.env.SOCKET_PATH;
}

app.get('/', function (req, res) {
  res.send('Hello World')
})

try {
  fs.unlinkSync(socketPath);
} catch(err) {
}

app.listen(socketPath, (err) => {
  if (err) throw err;
  fs.chmodSync(socketPath, 666);
  consola.ready({
    message: `Listening on socket ${socketPath}`,
    badge: true
  });
})
