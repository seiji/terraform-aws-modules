const consola = require('consola')
const express = require('express')
const fs = require('fs');

const app = express()

app.get('/', function (req, res) {
  res.send('Hello World')
})

const socketPath = '/tmp/express.sock';
fs.unlinkSync(socketPath);
app.listen(socketPath, (err) => {
  if (err) throw err;
  fs.chmodSync(socketPath, 660);
  consola.ready({
    message: `Listening on socket`,
    badge: true
  });
})
