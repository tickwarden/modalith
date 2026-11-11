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
        for name in ["template_save", "template_load", "template_delete", "guarded_button", "form_guard", "cooldown", "stats", "stats_reset", "progress", "progress_style", "auto_refresh", "auto_refresh_stop", "theme_register", "theme_apply", "themed_body", "translation_register", "locale_set", "translate", "localized_title", "localized_body", "localized_button", "state_set", "state_get", "state_remove", "state_clear", "notify", "notifications_show", "notification_next", "notifications_clear", "form_rules", "catalog_sorted"]:
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

    def test_no_turkish_text_in_runtime_or_documentation(self):
        import re
        for directory in [ROOT / "data", ROOT / "docs"]:
            for path in directory.rglob("*"):
                if path.is_file():
                    self.assertIsNone(re.search("[çğıöşüÇĞİÖŞÜ]", path.read_text()), str(path))


if __name__ == "__main__":
    unittest.main()
