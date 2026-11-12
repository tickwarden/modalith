"""Build deterministic core and optional demo datapacks using the standard library."""
from pathlib import Path
import argparse
import hashlib
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def _build(output: Path, source: Path, prefix: str) -> Path:
    version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise ValueError("VERSION must contain a stable semantic version")
    output.mkdir(parents=True, exist_ok=True)
    archive = output / f"{prefix}-{version}-mc26.3.zip"
    files = [source / "pack.mcmeta", ROOT / "LICENSE"]
    files += sorted(p for p in (source / "data").rglob("*") if p.is_file())
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for path in sorted(files):
            name = "LICENSE" if path == ROOT / "LICENSE" else path.relative_to(source).as_posix()
            info = zipfile.ZipInfo(name, date_time=(2025, 6, 17, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            z.writestr(info, path.read_bytes(), compresslevel=9)
    # Include only the current version's pair, in core-before-demo order.
    names = [f"modalith-{version}-mc26.3.zip", f"modalith-demo-{version}-mc26.3.zip"]
    (output / "SHA256SUMS").write_text("".join(
        f"{hashlib.sha256((output / name).read_bytes()).hexdigest()}  {name}\n"
        for name in names if (output / name).is_file()
    ), encoding="ascii")
    return archive


def build(output: Path) -> Path:
    return _build(output, ROOT / "mdl", "modalith")


def build_demo(output: Path) -> Path:
    return _build(output, ROOT / "mdl_demo", "modalith-demo")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "artifacts")
    args = parser.parse_args()
    print(build(args.output.resolve()))
    print(build_demo(args.output.resolve()))
