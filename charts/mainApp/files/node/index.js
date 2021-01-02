const http = require('http');
const { hostname } = require('os');
const { exec } = require('child_process');

console.info('Start application')
const server = http.createServer(handler);

let a = ''
let b = ''
let e = ''
exec('ls -lisaR /app-*', (error, stdout, stderr) => {
  e = error;
  a = stdout ?? '';
  b = stderr;
});

const host = hostname();
let withWait = false

function handler(req, res) {
  if (req.url === '/exit') {
    res.end('bye\n')
    server.close()

    return;
  }

  if (req.url === '/wait') {
    withWait = !withWait

    res.end('wait - switch -> '+(withWait ? 'on':'off')+'\n')
    return;
  }

  res.setHeader('Content-Type', 'application/json')

  if (withWait) {
    setTimeout(() => {
      res.end(JSON.stringify({
        hello: 'world',
        a: a.split('\n'),
        b: b.split('\n'),
        e,
        wait: true,
        method: req.method,
        url: req.url,
        params: req.params,
        host,
        env: process.env,
      }, null, 2) + "\n");
    }, 5000);
  } else {
    res.end(JSON.stringify({
      hello: 'world',
      a: a.split('\n'),
      b: b.split('\n'),
      e,
      method: req.method,
      url: req.url,
      params: req.params,
      host,
      env: process.env,
    }, null, 2) + "\n");
  }
}

server.listen(3000, () => {
  console.info('Start webserver')
});
