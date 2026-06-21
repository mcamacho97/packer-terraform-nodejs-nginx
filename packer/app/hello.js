const http = require('http');

const HOST = '0.0.0.0';
const PORT = 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/plain'
  });

  res.end('Aplicacion NodeJS desplegada mediante Packer\n');
});

server.listen(PORT, HOST, () => {
  console.log(`Server running on port ${PORT}`);
});