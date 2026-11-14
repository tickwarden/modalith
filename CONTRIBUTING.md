# Contributing

Thank you for improving Modalith. The intended repository is `tickwarden/modalith`; publication and its communication channels must be confirmed before relying on them.

## Development requirements

- Python 3.11+ for linting/build/release unit tests.
- Java 21 and vanilla Java Edition 26.3 for runtime testing.
- Node 22+ and the pinned test dependencies for protocol integration tests.

Run from the repository root:

```bash
python tools/lint.py
python -m unittest discover -s tests/unit -v
python tools/build.py
```

For runtime changes, follow `docs/TESTING.md` in a disposable local world. Update integration assertions and docs with any public API change. Never commit server jars, JREs, world saves, tokens, passwords, packet logs, or local dependency directories.

## Design rules

- Keep zero static production dialog JSON files.
- Keep callback names and privileged payloads server-owned.
- Fail closed on guard errors; never rely on visibility as authorization.
- Reissue tickets when rebuilding or cloning a session.
- Preserve synchronous/non-reentrant builder guarantees and document scratch lifetimes.
- Use compound text component parameters instead of raw string interpolation.
- Keep runtime UI, comments, examples, and documentation in English.
- Distinguish actual vanilla runtime tests from static checks and graphical/manual tests.

## Pull requests

Use a small branch and explain the problem, design, compatibility impact, and tests run. Add reproduction steps for bug fixes. Do not claim GitHub CI or a runtime suite passed unless it was actually run. Version/tag/release changes should be coordinated with the repository owner.

Contributions are made under the project's MIT license. Do not introduce third-party code without a compatible license and attribution. Follow `CODE_OF_CONDUCT.md` and report security issues privately as described in `SECURITY.md`.
