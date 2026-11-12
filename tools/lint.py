"""Static consistency checks, not a Minecraft command or macro parser."""
from pathlib import Path
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]


def lint():
    errors = []
    demo = ROOT / 'mdl_demo'
    roots = [ROOT / 'mdl/data', demo / 'data']
    for directory in [*roots, ROOT / 'tests/fixtures', ROOT / 'examples/action_hooks']:
        for path in directory.rglob('*.json'):
            try:
                json.loads(path.read_text(encoding='utf-8'))
            except (ValueError, UnicodeError) as exc:
                errors.append(f'{path.relative_to(ROOT)}: {exc}')
    for path in [ROOT / 'mdl/pack.mcmeta', demo / 'pack.mcmeta']:
        meta = json.loads(path.read_text())
        if meta['pack']['pack_format'] != 80:
            errors.append(f'{path}: pack_format must be 80')
    version = (ROOT / 'VERSION').read_text().strip()
    if not re.fullmatch(r'\d+\.\d+\.\d+', version):
        errors.append('Invalid semantic VERSION')
    if version not in (ROOT / 'mdl/pack.mcmeta').read_text():
        errors.append('Core pack description does not match VERSION')
    functions = {}
    for directory in roots:
        for path in directory.glob('*/function/**/*.mcfunction'):
            rel = path.relative_to(directory)
            name = rel.parts[0] + ':' + '/'.join(rel.parts[2:]).removesuffix('.mcfunction')
            functions[name] = path
    for name, path in functions.items():
        text = path.read_text()
        if re.search('[çğıöşüÇĞİÖŞÜ]', text):
            errors.append(f'{path.name}: untranslated runtime text')
        if name.startswith('mdl:') and ('mdl_demo:' in text or 'mdl.open' in text):
            errors.append(f'{path.name}: core depends on optional demo')
        for line in text.splitlines():
            if line.lstrip().startswith('#'):
                continue
            if line.startswith('$') and '$(' not in line:
                errors.append(f'{path.name}: macro line without variables')
            if re.search(r'\[-?\d+\]\{', line):
                errors.append(f'{path.name}: compound match directly after list index')
            for ref in re.findall(r'\bfunction ((?:mdl|mdl_demo):[a-z0-9_/]+)', line):
                if ref not in functions:
                    errors.append(f'{path.name}: missing {ref}')
            for tag in re.findall(r'\bfunction #mdl:([a-z0-9_/]+)', line):
                if not (ROOT / 'mdl/data/mdl/tags/function' / (tag + '.json')).is_file():
                    errors.append(f'{path.name}: missing tag mdl:{tag}')
    dialogs = [p for directory in roots for p in directory.glob('*/dialog/**/*.json')]
    if dialogs:
        errors.append('Unexpected static dialog registry JSON')
    print(f'{len(functions)} functions (core + optional demo); {len(dialogs)} static dialog JSON; {len(errors)} errors')
    return errors


if __name__ == '__main__':
    problems = lint()
    if problems:
        print('\n'.join(problems))
    sys.exit(bool(problems))
