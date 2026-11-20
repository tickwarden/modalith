'use strict';
// Local-only synthetic clients. Never expose the control port publicly.
const { spawnSync } = require('node:child_process');
const path = require('node:path');
const preflight = spawnSync(process.env.PYTHON || 'python', [path.join(__dirname, 'local_safety.py')], { encoding: 'utf8', env: process.env });
if (preflight.status !== 0) throw new Error('Local-only test preflight refused; no client connection attempted.');
const verified = JSON.parse(preflight.stdout);
function safePort(value) {
  if (!/^[0-9]+$/.test(String(value)) || !Number.isSafeInteger(Number(value)) || Number(value) < 1 || Number(value) > 65535) throw new Error('Invalid local test port.');
  return Number(value);
}
const gamePort = safePort(process.env.MDL_GAME_PORT || 25565);
if (gamePort !== verified.game_port) throw new Error('Game port differs from verified local test configuration.');
const port = safePort(process.env.MDL_CLIENT_PORT || 25581);
const mc = require('minecraft-protocol');
const fs = require('node:fs');
const net = require('node:net');
const clients = {};
const gameVersion = process.env.MDL_GAME_VERSION || '26.3';
if (!require('minecraft-data')(gameVersion)) {
  throw new Error(`Protocol fixtures do not support ${gameVersion}. Use tests/server_26_3.py for server-only checks; do not relabel older-version integration results.`);
}
const server = net.createServer(socket => {
  let buffer = '';
  socket.setEncoding('utf8');
  socket.on('error', error => console.error('Local control connection error (details omitted).'));
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
      socket.end('error: invalid local test request\n');
    }
  });
});
server.listen(port, '127.0.0.1', () => console.log(`Local test driver: ${port}`));
function connect(username) {
  const client = mc.createClient({
    host: verified.host, port: gamePort,
    username, version: gameVersion, auth: 'offline'
  });
  clients[username] = client;
  client.on('login', () => {
    console.log('Synthetic test client connected (not a human player).');
    if (username === 'Tester') setTimeout(() => connect('Other'), 1200);
  });
  client.on('packet', (data, meta) => {
    if (process.env.MDL_CAPTURE_DIALOGS === '1' && meta.name.includes('dialog')) {
      fs.appendFileSync('packets.jsonl', JSON.stringify({ client: "synthetic", name: meta.name, data }) + '\n');
    }
  });
  client.on('error', error => console.error('Synthetic client error (details omitted).'));
  client.on('end', reason => console.log('Synthetic test client disconnected.'));
}
connect('Tester');
function shutdown() {
  for (const client of Object.values(clients)) client.end();
  server.close();
}
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
