"""Offline adversarial preflight tests: no public service or game connections."""
from pathlib import Path
import json
import os
import sys
import tempfile
import subprocess
import shutil
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tests'))
from local_safety import loopback_host, port, require_local_test_environment, verify_server
from prepare_local_server import prepare


class LocalSafetyTests(unittest.TestCase):
    def test_remote_dns_wildcard_and_metadata_hosts_rejected_without_dns(self):
        with patch('socket.getaddrinfo', side_effect=AssertionError('DNS forbidden')):
            for host in ['0.0.0.0', '::', '8.8.8.8', '192.168.1.1', '169.254.169.254',
                         'example.com', 'localhost', '127.0.0.1.example.com', '2130706433',
                         '127.1', '', '::ffff:8.8.8.8']:
                with self.subTest(host=host), self.assertRaises(ValueError):
                    loopback_host(host)
        self.assertEqual(loopback_host('127.0.0.1'), '127.0.0.1')
        self.assertEqual(loopback_host('::1'), '::1')

    def test_invalid_ports_rejected(self):
        for value in ['0', '-1', '65536', '1.5', '1e3', 'NaN', 'Infinity', '', ' 80', '\u0661']:
            with self.subTest(value=value), self.assertRaises(ValueError):
                port(value)
        self.assertEqual(port('25575'), 25575)

    def test_generated_server_has_no_public_status_and_no_human_identities(self):
        with tempfile.TemporaryDirectory() as tmp:
            prepare(tmp)
            config = verify_server(tmp)
            self.assertEqual(config['server-ip'], '127.0.0.1')
            self.assertEqual(config['enable-status'], 'false')
            self.assertEqual(config['enable-query'], 'false')
            self.assertEqual(config['log-ips'], 'false')
            self.assertIn('Synthetic clients only', config['motd'])
            self.assertEqual(json.loads((Path(tmp) / 'ops.json').read_text()), [])
            self.assertEqual({x['name'] for x in json.loads((Path(tmp) / 'whitelist.json').read_text())}, {'Tester', 'Other'})
            with self.assertRaises(ValueError):
                prepare(tmp)

    def test_unsafe_settings_and_public_bind_fail_closed(self):
        for old, new in [('server-ip=127.0.0.1','server-ip=0.0.0.0'),
                         ('enable-status=false','enable-status=true'),
                         ('enable-query=false','enable-query=true'),
                         ('white-list=true','white-list=false'),
                         ('log-ips=false','log-ips=true')]:
            with tempfile.TemporaryDirectory() as tmp:
                prepare(tmp)
                p = Path(tmp) / 'server.properties'
                p.write_text(p.read_text().replace(old, new))
                with self.assertRaises(ValueError):
                    verify_server(tmp)

    def test_operator_or_unexpected_identity_rejected(self):
        for filename, content in [('ops.json',[{'name':'Tester'}]),
                                  ('whitelist.json',[{'name':'Human','uuid':'not-a-real-id'}])]:
            with tempfile.TemporaryDirectory() as tmp:
                prepare(tmp)
                (Path(tmp) / filename).write_text(json.dumps(content))
                with self.assertRaises(ValueError):
                    verify_server(tmp)

    def test_explicit_ack_and_matching_local_destination_required(self):
        with tempfile.TemporaryDirectory() as tmp:
            prepare(tmp)
            with patch.dict(os.environ, {}, clear=True), self.assertRaises(ValueError):
                require_local_test_environment()
            env = {'MDL_LOCAL_TEST_ACK':'1','MDL_TEST_SERVER_DIR':tmp}
            with patch.dict(os.environ, env, clear=True):
                self.assertEqual(require_local_test_environment(), ('127.0.0.1',25575))
            for host in ['8.8.8.8','example.com','::1']:
                with patch.dict(os.environ, {**env, 'MDL_RCON_HOST':host}, clear=True), self.assertRaises(ValueError):
                    require_local_test_environment()

    def test_packet_capture_is_explicit_opt_in_and_errors_are_redacted(self):
        client = (ROOT / 'tests/clients.js').read_text()
        self.assertIn("process.env.MDL_CAPTURE_DIALOGS === '1'", client)
        self.assertNotIn('error.message', client)
        self.assertNotIn('console.log(`${username}', client)
        self.assertIn('Synthetic test client connected (not a human player)', client)

    def test_real_entrypoints_refuse_before_optional_dependencies_or_connections(self):
        env = {k:v for k,v in os.environ.items() if not k.startswith('MDL_')}
        for script in ['integration.py', 'server_26_3.py', 'server_nine.py']:
            result = subprocess.run([sys.executable, str(ROOT / 'tests' / script)], env=env, capture_output=True, text=True, timeout=10)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('MDL_LOCAL_TEST_ACK', result.stderr)
        if shutil.which('node'):
            result = subprocess.run(['node', str(ROOT / 'tests/clients.js')], env=env, capture_output=True, text=True, timeout=10)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('preflight refused', result.stderr)
            self.assertNotIn('Cannot find module', result.stderr)
            with tempfile.TemporaryDirectory() as tmp:
                prepare(tmp)
                env.update({'MDL_LOCAL_TEST_ACK':'1','MDL_TEST_SERVER_DIR':tmp,'PYTHON':sys.executable,'MDL_GAME_PORT':'25566'})
                result = subprocess.run(['node', str(ROOT / 'tests/clients.js')], env=env, capture_output=True, text=True, timeout=10)
                self.assertIn('Game port differs', result.stderr)

    def test_duplicate_properties_rejected_instead_of_ambiguous_config(self):
        with tempfile.TemporaryDirectory() as tmp:
            prepare(tmp)
            p = Path(tmp) / 'server.properties'
            p.write_text(p.read_text() + 'server-ip=0.0.0.0\n')
            with self.assertRaises(ValueError):
                verify_server(tmp)

    def test_diagnostics_ring_and_record_shape_have_no_identity_or_payload(self):
        report = (ROOT / 'mdl/data/mdl/function/internal/diagnostic/report.mcfunction').read_text()
        self.assertIn('matches 33..', report)
        self.assertIn('records[0]', report)
        self.assertIn('matches ..2147483646', report)
        for forbidden in ['UUID', 'player_id', 'payload', 'tellraw', 'say ', 'entity @s']:
            self.assertNotIn(forbidden, report)
        for name in ['diagnostics','diagnostics_clear','diagnostics_enabled']:
            self.assertTrue((ROOT / 'mdl/data/mdl/function/api' / (name + '.mcfunction')).is_file())


if __name__ == '__main__':
    unittest.main()
