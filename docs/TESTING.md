# Testing — 2.3 / Minecraft 26.3

## Latest target and real-server validation

The official vanilla **26.3** dedicated server runs with **Java 25**. Its embedded version.json declares data pack version **121.0** and protocol **777**. Metadata uses min_format/max_format arrays, not legacy pack_format 80.

**68/68 RCON server checks pass**, recorded in `TEST_RESULTS.json` and `tests/run-metadata.json`. They exercise:

- Known-good and deliberately invalid dialog codec controls.
- Last-button label and tooltip setters, complete styled/quoted components and missing-target rejection.
- Body clearing and rebuilding without clearing buttons.
- Columns 1/3/8, invalid 0/9/fractional values and notice rejection.
- All three after_action values, invalid-mode rejection and none/pause consistency.
- Legacy options delegation, escape validation and no partial mutation on invalid inputs.
- Native URL/suggest/copy/inline-dialog/run_command codec instantiation.
- Item bodies, four input codecs, dynamic numeric submission action and notice tooltips.

Core, demo and test fixtures load on the official server. Tested production data is compared byte-for-byte against the source. A real upgrade issue in the demo predicate discriminator was found and migrated from condition to type before validation.

### What these checks do NOT establish

There are intentionally **zero players** in this server test. Complete dialogs are passed into a test macro; Minecraft parses their actual command argument codecs when instantiating it, before target resolution. A negative control confirms malformed types are rejected. Long definitions remain in server storage to respect the RCON command length limit.

This establishes real-server setter execution and codec acceptance, **not graphical display, client interaction, or end-to-end player callback/session compatibility**. There is no manual UI QA, permission/stock/TPS certification, or Paper/Fabric/proxy compatibility claim.

## Historical player integration

The pinned `minecraft-protocol 1.68.0` supports up to 26.1, not a complete 26.3 protocol schema. The client driver now fails explicitly instead of silently using an older schema. `tests/integration.py` remains the full protocol suite but was **not run on 26.3**.

The earlier **178/178** Minecraft 1.21.6 / Java 21 player assertions and source hashes are preserved in `tests/history/2.1.0/`. They are historical regression evidence, **not** the current version's player-integration result. Completing this gap requires supported 26.3 clients followed by the full suite on a disposable world.

## Static, unit and PR checks

From the repository root:

```bash
python tools/lint.py
python -m unittest discover -s tests/unit -v
python tools/build.py
cd artifacts && sha256sum --check SHA256SUMS
```

**14/14 unit/layout tests** pass. They validate format ranges, the new predicate discriminator, APIs, draft validation structure, English docs/runtime, empty production observer tags, separate deterministic core/demo ZIPs and no demo references in core. Static checks are not a complete Minecraft command/macro parser.

PR CI runs these static/unit/build/checksum checks and uploads both artifacts. It does not start Minecraft or imply the real-server suite ran on GitHub.

## Reproduce the 26.3 server checks

1. Obtain official 26.3 and Java 25. Review/accept Mojang's EULA yourself.
2. Use a disposable, localhost-only world. Install `mdl/` as core, `mdl_demo/` as optional demo, and `tests/fixtures/hooks` as a third test datapack. **Never deploy the fixture pack to production.**
3. Enable localhost RCON, default port 25575 and test-only password `local-test-only`. Environment overrides: MDL_RCON_HOST, MDL_RCON_PORT, MDL_RCON_PASSWORD.
4. Install Python dependencies: `pip install -r tests/requirements.txt`.
5. In a writable scratch directory run `python /path/to/repository/tests/server_26_3.py`.
6. Inspect `SERVER_26_3_RESULTS.json`, stdout and server load logs. No synthetic clients are needed for this narrower suite.

The optional demo must be installed separately for graphical/manual testing; `/trigger mdl.open` belongs only to that pack. Both archives place pack.mcmeta at their roots, with no extra source folder.

## 2.3 widget coverage

The suite retains the previous 35 checks and adds 33 widget assertions: component value/quote/style preservation, one-body output, width boundaries and fractional rejection, key-value row order/missing fields/0–32 bounds, checklist state markers/invalid status/32-entry boundary, and step position/16-entry bounds. Invalid-input checks compare body snapshots to confirm no partial append. The test reader normalizes SNBT control-character escapes because nbtlib 2 predates the server newline escape syntax. This is a test-reader compatibility shim, not a production-data change. Native codec instantiation uses a positive and negative control; zero synthetic players are involved. 2.2 results are archived in tests/history/2.2.0.
