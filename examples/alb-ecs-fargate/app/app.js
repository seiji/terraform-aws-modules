const consola = require('consola')
const express = require('express')
const fs = require('fs');
const app = express()
const AWS = require("aws-sdk");
AWS.config.update({
  region: "ap-northeast-1"
});

const s3 = new AWS.S3({
  apiVersion: '2006-03-01',
  params: {Bucket: 'data.seiji.me'}
});

var socketPath = '/tmp/express.sock';
if (process.env.SOCKET_PATH) {
  socketPath = process.env.SOCKET_PATH;
}


app.get('/', function (req, res) {
  // res.send('Hello World')
  s3.listObjects({Delimiter: '/'}, function(err, data) {
    res.send(data);
  });
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
