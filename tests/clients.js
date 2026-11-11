'use strict';
// Local-only synthetic clients. Never expose the control port publicly.
const mc = require('minecraft-protocol');
const fs = require('node:fs');
const net = require('node:net');
const clients = {};
const port = Number(process.env.MDL_CLIENT_PORT || 25581);
const server = net.createServer(socket => {
  let buffer = '';
  socket.setEncoding('utf8');
  socket.on('error', error => console.error('Control connection:', error.message));
  socket.on('data', chunk => {
    buffer += chunk;
    if (buffer.length > 65536) return socket.destroy();
    if (!buffer.includes('\n')) return;
    try {
      const request = JSON.parse(buffer.split('\n', 1)[0]);
      const client = clients[request.player];
      if (!client || client.state !== 'play') throw new Error('Client is not in play state');
      if (typeof request.command !== 'string') throw new Error('Command must be a string');
      client.write('chat_command', { command: request.command });
      socket.end('sent\n');
    } catch (error) {
      socket.end(`error: ${error.message}\n`);
    }
  });
});
server.listen(port, '127.0.0.1', () => console.log(`Local test driver: ${port}`));
function connect(username) {
  const client = mc.createClient({
    host: '127.0.0.1', port: Number(process.env.MDL_GAME_PORT || 25565),
    username, version: '1.21.6', auth: 'offline'
  });
  clients[username] = client;
  client.on('login', () => {
    console.log(`${username} LOGIN`);
    if (username === 'Tester') setTimeout(() => connect('Other'), 1200);
  });
  client.on('packet', (data, meta) => {
    if (meta.name.includes('dialog')) {
      fs.appendFileSync('packets.jsonl', JSON.stringify({ username, name: meta.name, data }) + '\n');
    }
  });
  client.on('error', error => console.error(username, error.message));
  client.on('end', reason => console.log(`${username} END ${reason}`));
}
connect('Tester');
function shutdown() {
  for (const client of Object.values(clients)) client.end();
  server.close();
}
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
