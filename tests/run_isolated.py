"""Linux-only isolated live-test harness, invoked inside a fresh network namespace.

Example (after reviewed preparation/download/EULA):
sudo env MDL_HOST_NETNS="$(readlink /proc/self/ns/net)" unshare -n sh -c 'ip link set lo up; exec runuser -u user -- /usr/local/bin/python tests/run_isolated.py RUNTIME'
No namespace creation, downloads or EULA acceptance occurs in this script.
"""
from pathlib import Path
import os
import subprocess
import sys
import socket
import time

ROOT=Path(__file__).resolve().parents[1]

def main():
    runtime=Path(sys.argv[1]).resolve()
    # Require only loopback; a shared host namespace or another interface fails closed.
    if {name for _,name in socket.if_nameindex()} != {'lo'}:
        raise SystemExit('Refusing server launch: network namespace must contain only loopback.')
    if not os.getenv('MDL_HOST_NETNS') or os.readlink('/proc/self/ns/net') == os.environ['MDL_HOST_NETNS']:
        raise SystemExit('Refusing shared host network namespace.')
    os.environ.update(MDL_LOCAL_TEST_ACK='1',MDL_TEST_SERVER_DIR=str(runtime))
    from local_safety import verify_server
    verify_server(runtime)
    java=next(runtime.glob('jdk*/bin/java'))
    env=os.environ.copy()
    rc=1
    with (runtime/'harness-server.log').open('w') as log:
        server=subprocess.Popen([str(java),'--enable-native-access=ALL-UNNAMED','-Xms512M','-Xmx1200M','-jar','server.jar','nogui'],cwd=runtime,stdout=log,stderr=subprocess.STDOUT,stdin=subprocess.PIPE,text=True)
        try:
            deadline=time.monotonic()+120
            while time.monotonic()<deadline:
                if server.poll() is not None:raise RuntimeError('Server exited before ready.')
                if 'RCON running on 127.0.0.1:' in (runtime/'harness-server.log').read_text():break
                time.sleep(.25)
            else:raise RuntimeError('Server startup timed out.')
            import json
            (runtime/'isolation.json').write_text(json.dumps({'interfaces':['lo'],'network_namespace':os.readlink('/proc/self/ns/net'),'parent_network_namespace':os.environ['MDL_HOST_NETNS'],'external_interface':False,'test_transport':'RCON loopback only; no player clients'},indent=2)+'\n')
            rc=0
            for name in ['server_26_3.py','server_nine.py']:
                result=subprocess.run([sys.executable,str(ROOT/'tests'/name)],cwd=runtime,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=90)
                (runtime/(name+'.txt')).write_text(result.stdout)
                print(result.stdout,flush=True)
                rc=max(rc,result.returncode)
        finally:
            if server.poll() is None:
                try:
                    server.stdin.write('stop\n');server.stdin.flush();server.wait(timeout=30)
                except (OSError,subprocess.TimeoutExpired):
                    server.kill();server.wait()
    return rc

if __name__=='__main__':raise SystemExit(main())
