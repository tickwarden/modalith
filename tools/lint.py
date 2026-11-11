"""Static consistency checks; not a Minecraft command or macro parser."""
from pathlib import Path
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]


def lint():
    errors = []
    for directory in (ROOT / "data", ROOT / "tests" / "fixtures"):
        for path in directory.rglob("*.json"):
            try:
                json.loads(path.read_text(encoding="utf-8"))
            except (ValueError, UnicodeError) as exc:
                errors.append(f"{path.relative_to(ROOT)}: {exc}")
    meta = json.loads((ROOT / "pack.mcmeta").read_text(encoding="utf-8"))
    if meta["pack"]["pack_format"] != 80:
        errors.append("pack_format must be 80 for Java 1.21.6")
    version = (ROOT / "VERSION").read_text().strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        errors.append("Invalid semantic VERSION")
    if version not in meta["pack"]["description"]:
        errors.append("pack.mcmeta description does not match VERSION")
    base = ROOT / "data" / "mdl" / "function"
    functions = {p.relative_to(base).as_posix().removesuffix(".mcfunction") for p in base.rglob("*.mcfunction")}
    for path in (ROOT / "data").glob("*/function/**/*.mcfunction"):
        text = path.read_text(encoding="utf-8")
        if re.search("[çğıöşüÇĞİÖŞÜ]", text):
            errors.append(f"{path.relative_to(ROOT)}: untranslated Turkish characters")
        for number, line in enumerate(text.splitlines(), 1):
            if line.lstrip().startswith("#"):
                continue
            for ref in re.findall(r"\bfunction mdl:([a-z0-9_/]+)", line):
                if ref not in functions:
                    errors.append(f"{path.name}:{number}: missing mdl:{ref}")
            for tag in re.findall(r"\bfunction #mdl:([a-z0-9_/]+)", line):
                if not (ROOT / "data" / "mdl" / "tags" / "function" / (tag + ".json")).is_file():
                    errors.append(f"{path.name}:{number}: missing function tag mdl:{tag}")
    all_functions = {p.relative_to(ROOT / "data").parts[0] + ":" + p.as_posix().split("/function/", 1)[1].removesuffix(".mcfunction") for p in (ROOT / "data").glob("*/function/**/*.mcfunction")}
    for path in (ROOT / "data").glob("*/function/**/*.mcfunction"):
        for line in path.read_text().splitlines():
            if line.lstrip().startswith("#"):
                continue
            for ref in re.findall(r"\bfunction (mdl_demo:[a-z0-9_/]+)", line):
                if ref not in all_functions:
                    errors.append(f"{path.name}: missing {ref}")
    dialogs = list((ROOT / "data").glob("*/dialog/**/*.json"))
    if dialogs:
        errors.append("Unexpected static dialog registry JSON")
    print(f"{len(all_functions)} functions; {len(dialogs)} static dialog JSON; {len(errors)} errors")
    return errors


if __name__ == "__main__":
    problems = lint()
    print("\n".join(problems)) if problems else None
    sys.exit(bool(problems))
