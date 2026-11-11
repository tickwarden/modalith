"""Create a deterministic, installable datapack ZIP (Python standard library only)."""
from pathlib import Path
import argparse
import hashlib
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def build(output: Path) -> Path:
    version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise ValueError("VERSION must contain a stable semantic version")
    output.mkdir(parents=True, exist_ok=True)
    archive = output / f"modalith-{version}-mc1.21.6.zip"
    files = [ROOT / "pack.mcmeta", ROOT / "LICENSE"]
    files += sorted(p for p in (ROOT / "data").rglob("*") if p.is_file())
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for path in sorted(files):
            info = zipfile.ZipInfo(path.relative_to(ROOT).as_posix(), date_time=(2025, 6, 17, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            z.writestr(info, path.read_bytes(), compresslevel=9)
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    (output / "SHA256SUMS").write_text(f"{digest}  {archive.name}\n", encoding="ascii")
    return archive


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "artifacts")
    args = parser.parse_args()
    print(build(args.output.resolve()))
