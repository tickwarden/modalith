"""Create private synthetic-test settings, never a public Minecraft server.

Does not download/run a server or accept Mojang's EULA. Never overwrites existing settings.
"""
import argparse
import json
from pathlib import Path
from local_safety import SYNTHETIC_NAMES, offline_uuid


def prepare(directory):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    names = ['server.properties', 'whitelist.json', 'ops.json']
    if any((directory / name).exists() for name in names):
        raise ValueError('Refusing to overwrite existing server/identity settings.')
    config = '''server-ip=127.0.0.1
server-port=25565
enable-rcon=true
rcon.port=25575
rcon.password=local-test-only
online-mode=false
enable-status=false
enable-query=false
white-list=true
enforce-whitelist=true
max-players=2
log-ips=false
motd=[LOCAL TEST] Synthetic clients only - NOT a public server
spawn-protection=0
view-distance=2
simulation-distance=2
level-type=minecraft:normal
'''
    (directory / 'server.properties').write_text(config)
    (directory / 'whitelist.json').write_text(json.dumps([
        {'uuid': offline_uuid(name), 'name': name} for name in SYNTHETIC_NAMES
    ], indent=2) + '\n')
    (directory / 'ops.json').write_text('[]\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    args = parser.parse_args()
    prepare(args.directory)
    print('LOCAL TEST ONLY: no humans, public listing, tunnelling or port forwarding.')
    print('Mojang EULA acceptance and server launch remain explicit separate steps.')
