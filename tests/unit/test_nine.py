"""Structural regression tests; the live suite supplies runtime/codec evidence."""
from pathlib import Path
import os
import subprocess
import sys
import unittest

ROOT=Path(__file__).resolve().parents[2]
R=ROOT/'mdl/data/mdl/function'

class NineFeatureTests(unittest.TestCase):
    def test_exact_nine_public_feature_entrypoints(self):
        names=['widget/callout','widget/comparison','widget/timeline','escape','pause','body_width','validate','body_set','body_remove']
        self.assertEqual(len(set(names)),9)
        for name in names:
            self.assertTrue((R/'api'/(name+'.mcfunction')).is_file(),name)

    def test_default_width_has_reset_template_copy_and_explicit_path(self):
        self.assertIn('body_width set value 300',(R/'api/begin.mcfunction').read_text())
        self.assertIn('source.body_width',(R/'api/template_load.mcfunction').read_text())
        self.assertIn('$(width)',(R/'api/body.mcfunction').read_text())
        default=(R/'api/body_default.mcfunction').read_text()
        self.assertIn('body_width',default)
        self.assertNotIn('$(width)',default)
        self.assertIn('return run function mdl:api/body',default)

    def test_widgets_emit_only_after_validation(self):
        for name in ['callout','comparison','timeline']:
            s=(R/'api/widget'/(name+'.mcfunction')).read_text()
            self.assertLess(s.index('internal/widget/width'),s.index('internal/widget/emit'))
            self.assertIn('diagnostic/error',s)
        for name in ['comparison','timeline']:
            s=(R/'api/widget'/(name+'.mcfunction')).read_text()
            self.assertIn('matches 0..32',s)
            self.assertIn('probe append value {}',s)
            self.assertIn('unless score #widget_valid',s)

    def test_validator_is_read_only_for_work_storage(self):
        for p in [R/'api/validate.mcfunction',*(R/'internal/ui').glob('validate*.mcfunction')]:
            for line in p.read_text().splitlines():
                self.assertNotIn('data modify storage mdl:work',line)
                self.assertNotIn('data remove storage mdl:work',line)
                self.assertNotIn('data merge storage mdl:work',line)

    def test_body_edit_guards_precede_mutation(self):
        for name in ['body_set','body_remove']:
            s=(R/'api'/(name+'.mcfunction')).read_text()
            self.assertIn('E_NO_DRAFT',s)
            self.assertIn('internal/ui/integer',s)
            helper=(R/'internal/ui'/(name+'.mcfunction')).read_text()
            self.assertIn('E_BODY_INDEX',helper)
            self.assertLess(helper.index('E_BODY_INDEX'),helper.rindex('storage mdl:work dialog.body'))
        self.assertIn('E_BODY_NOT_TEXT',(R/'internal/ui/body_set.mcfunction').read_text())

    def test_pause_none_has_explicit_rejection_and_normalization(self):
        self.assertIn('E_PAUSE_AFTER_ACTION',(R/'api/pause.mcfunction').read_text())
        self.assertIn('pause set value 0b',(R/'api/after_action.mcfunction').read_text())

    def test_isolated_harness_refuses_shared_network_before_java(self):
        result=subprocess.run([sys.executable,str(ROOT/'tests/run_isolated.py'),str(ROOT)],capture_output=True,text=True,timeout=10,env=os.environ.copy())
        self.assertNotEqual(result.returncode,0)
        self.assertIn('Refusing server launch',result.stderr)

    def test_demo_is_optional_and_discoverable(self):
        home=(ROOT/'mdl_demo/data/mdl_demo/function/demo/home.mcfunction').read_text()
        self.assertIn('mdl_demo:demo/nine_features',home)
        for p in (ROOT/'mdl/data').rglob('*.mcfunction'):
            self.assertNotIn('mdl_demo:',p.read_text())

if __name__=='__main__':unittest.main()
