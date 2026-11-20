"""Fail-closed safeguards for disposable synthetic tests; not a network firewall."""
import hashlib
import ipaddress
import json
import os
import sys
from pathlib import Path
import uuid

SYNTHETIC_NAMES = ('Tester', 'Other')


def loopback_host(value):
    try:
        address = ipaddress.ip_address(value)
    except ValueError:
        raise ValueError('Only literal loopback addresses are allowed; DNS names are rejected.') from None
    if not address.is_loopback:
        raise ValueError('Non-loopback test connections are forbidden.')
    return str(address)


def port(value):
    value = str(value)
    if not value.isascii() or not value.isdecimal() or not 1 <= int(value) <= 65535:
        raise ValueError('Test port must be an integer in 1..65535.')
    return int(value)


def offline_uuid(name):
    return str(uuid.UUID(bytes=hashlib.md5(('OfflinePlayer:' + name).encode()).digest(), version=3))


def properties(path):
    result = {}
    for line in path.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith(('#', '!')) and '=' in line:
            key, value = line.split('=', 1)
            if key.strip() in result:
                raise ValueError('Duplicate server properties are not accepted by test preflight.')
            result[key.strip()] = value.strip()
    return result


def verify_server(directory):
    directory = Path(directory)
    config = properties(directory / 'server.properties')
    loopback_host(config.get('server-ip', ''))
    required = {'enable-status': 'false', 'enable-query': 'false', 'white-list': 'true',
                'enforce-whitelist': 'true', 'online-mode': 'false', 'log-ips': 'false',
                'max-players': '2', 'enable-rcon': 'true'}
    if any(config.get(key) != value for key, value in required.items()):
        raise ValueError('Unsafe test server settings; use prepare_local_server.py.')
    if config.get('motd') != '[LOCAL TEST] Synthetic clients only - NOT a public server':
        raise ValueError('Test server must carry the explicit synthetic/local MOTD.')
    if json.loads((directory / 'ops.json').read_text()) != []:
        raise ValueError('Synthetic test players must not be operators.')
    whitelist = json.loads((directory / 'whitelist.json').read_text())
    expected = [{'uuid': offline_uuid(name), 'name': name} for name in SYNTHETIC_NAMES]
    if not isinstance(whitelist, list) or sorted(whitelist, key=lambda x: str(x)) != sorted(expected, key=lambda x: str(x)):
        raise ValueError('Whitelist must contain exactly the two synthetic test identities.')
    for key in ['server-port', 'rcon.port']:
        port(config.get(key, ''))
    return config


def require_local_test_environment():
    if os.getenv('MDL_LOCAL_TEST_ACK') != '1':
        raise ValueError('Set MDL_LOCAL_TEST_ACK=1 only for your disposable localhost test server.')
    directory = os.getenv('MDL_TEST_SERVER_DIR')
    if not directory:
        raise ValueError('MDL_TEST_SERVER_DIR is required for fail-closed test preflight.')
    host = loopback_host(os.getenv('MDL_RCON_HOST', '127.0.0.1'))
    config = verify_server(directory)
    if host != loopback_host(config['server-ip']):
        raise ValueError('Test destination must match the verified server bind address.')
    rcon_port = port(os.getenv('MDL_RCON_PORT', '25575'))
    if rcon_port != port(config['rcon.port']):
        raise ValueError('RCON port does not match verified test settings.')
    return host, rcon_port


if __name__ == '__main__':
    try:
        host, _ = require_local_test_environment()
        config = verify_server(os.environ['MDL_TEST_SERVER_DIR'])
        print(json.dumps({'host': host, 'game_port': port(config['server-port'])}))
    except (ValueError, OSError, KeyError, TypeError):
        print('Local test preflight refused; review local safety setup.', file=sys.stderr)
        raise SystemExit(1)
