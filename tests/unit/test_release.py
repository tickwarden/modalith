"""Release/layout regression tests. These do not execute Minecraft commands."""
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("modalith_build", ROOT / "tools" / "build.py")
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)


class ReleaseTests(unittest.TestCase):
    def test_supported_target(self):
        self.assertEqual(json.loads((ROOT / "pack.mcmeta").read_text())["pack"]["pack_format"], 80)

    def test_version_consistency(self):
        version = (ROOT / "VERSION").read_text().strip()
        self.assertIn(version, (ROOT / "README.md").read_text())
        self.assertIn(version, (ROOT / "pack.mcmeta").read_text())
        self.assertIn(version, (ROOT / "CHANGELOG.md").read_text())

    def test_zip_root_and_no_test_hooks(self):
        with tempfile.TemporaryDirectory() as tmp:
            archive = builder.build(Path(tmp))
            with zipfile.ZipFile(archive) as z:
                names = z.namelist()
                self.assertIn("pack.mcmeta", names)
                self.assertIn("data/mdl/function/load.mcfunction", names)
                self.assertFalse(any("mdl_test" in n or n.startswith(("tests/", ".github/")) for n in names))
                self.assertFalse(any("/dialog/" in n for n in names))
                self.assertIsNone(z.testzip())

    def test_deterministic_zip_and_checksum(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            first = builder.build(directory).read_bytes()
            second = builder.build(directory).read_bytes()
            self.assertEqual(first, second)
            self.assertTrue((directory / "SHA256SUMS").read_text().startswith(hashlib.sha256(first).hexdigest()))

    def test_new_public_apis_exist(self):
        for name in ["template_save", "template_load", "template_delete", "guarded_button", "form_guard", "cooldown", "stats", "stats_reset", "progress", "progress_style", "auto_refresh", "auto_refresh_stop", "theme_register", "theme_apply", "themed_body", "translation_register", "locale_set", "translate", "localized_title", "localized_body", "localized_button", "state_set", "state_get", "state_remove", "state_clear", "notify", "notifications_show", "notification_next", "notifications_clear", "form_rules", "catalog_sorted", "button_width", "exit_width", "action_delay", "action_delay_cancel", "action_conditional", "button_enabled", "catalog_filter", "favorite_set", "favorite_get", "favorite_remove", "favorites_clear", "catalog_favorites"]:
            self.assertTrue((ROOT / "data" / "mdl" / "function" / "api" / f"{name}.mcfunction").is_file())

    def test_observer_tags_are_empty_in_production(self):
        for name in ["event", "show", "close", "timeout", "reject", "before_action", "after_action"]:
            path = ROOT / "data" / "mdl" / "tags" / "function" / f"{name if name in ['before_action', 'after_action'] else 'on_' + name}.json"
            self.assertEqual(json.loads(path.read_text())["values"], [])

    def test_typed_dispatch_and_actions(self):
        for name in ['function', 'run_command', 'close', 'refresh', 'open_url', 'suggest_command', 'copy_to_clipboard', 'show_dialog']:
            self.assertTrue((ROOT / 'data/mdl/function/action' / (name + '.mcfunction')).is_file())
        self.assertEqual((ROOT / 'data/mdl/function/action/run_command.mcfunction').read_text().strip(), '$$(cmd)')
        for path in (ROOT / 'data').rglob('*.mcfunction'):
            self.assertNotIn('callback:"', path.read_text())
        self.assertFalse((ROOT / 'data/mdl/function/demo').exists())
        self.assertTrue((ROOT / 'data/mdl_demo/function/demo/actions.mcfunction').is_file())

    def test_updated_examples_and_optional_hook_pack(self):
        home = (ROOT / 'data/mdl_demo/function/demo/home.mcfunction').read_text()
        self.assertIn('mdl_demo:demo/actions', home)
        actions = (ROOT / 'data/mdl_demo/function/demo/actions.mcfunction').read_text()
        for token in ['type:"close"', 'type:"refresh"', 'type:"run_command"', 'key:"action_demo"']:
            self.assertIn(token, actions)
        example = ROOT / 'examples/action_hooks'
        self.assertEqual(json.loads((example / 'pack.mcmeta').read_text())['pack']['pack_format'], 80)
        for hook in ['before_action', 'after_action']:
            value = json.loads((example / 'data/mdl/tags/function' / (hook + '.json')).read_text())['values'][0]
            ns, path = value.split(':')
            self.assertTrue((example / 'data' / ns / 'function' / (path + '.mcfunction')).is_file())
        with tempfile.TemporaryDirectory() as tmp:
            with zipfile.ZipFile(builder.build(Path(tmp))) as z:
                self.assertFalse(any('mdl_example' in n for n in z.namelist()))

    def test_width_setter_validation_precedes_target_mutation(self):
        for name, target in [('button_width', 'dialog.actions[-1]'), ('exit_width', 'dialog.exit_action')]:
            text = (ROOT / 'data/mdl/function/api' / (name + '.mcfunction')).read_text()
            self.assertIn('matches 1..1024 run return 0', text)
            self.assertIn('check.width int 1', text)
            self.assertIn('score #width_type mdl.tmp matches 1 run return 0', text)
            self.assertIn('unless data storage mdl:work ' + target + ' run return 0', text)
            self.assertLess(text.index('matches 1..1024'), text.index(target + '.width set'))

    def test_no_turkish_text_in_runtime_or_documentation(self):
        import re
        for directory in [ROOT / "data", ROOT / "docs"]:
            for path in directory.rglob("*"):
                if path.is_file():
                    self.assertIsNone(re.search("[çğıöşüÇĞİÖŞÜ]", path.read_text()), str(path))


if __name__ == "__main__":
    unittest.main()
