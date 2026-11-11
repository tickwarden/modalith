# Testing

## Scope of the latest local run

Runtime checks use the official vanilla Minecraft **1.21.6** dedicated server with Java 21 and two non-OP protocol clients, `Tester` and `Other`. The isolated test server uses offline mode on localhost; its `ops.json` is empty. This configuration is for tests only, not a production recommendation.

Player submissions are actual serverbound `chat_command` packets. Setup/inspection uses local RCON. Clientbound `show_dialog` packets are decoded by `minecraft-protocol`.

The recorded 2.0.0 run passes **140/140 integration assertions**. Machine-readable results are in `TEST_RESULTS.json`. It covers the previous 28 checks plus template ownership/rekeying, native footer/form template rekeying, predicate denial/permission changes/missing predicates, form guards, cooldown rejection/retry, lifecycle observer behavior, and metrics snapshot/reset semantics. Version 1.2 added 26 progress/live-view assertions; version 1.3 adds 44 checks for themes, locale fallback and persistence, state isolation, bounded notification FIFO/return behavior, numeric validation, stable rank sorting, the 64-row boundary, and sorted payload dispatch.

Operator status is verified separately by the test server's empty `ops.json`; connection-presence assertions do not establish permission level.

Eight standard-library unit tests separately check release layout, deterministic packaging/checksums, version consistency, production observer isolation, new API files, and English runtime/docs. Static checks validate JSON, local function/tag references, and the absence of static dialog JSON. They do not parse Minecraft command syntax or execute macros.

## What is not claimed

- No graphical Minecraft client was used for manual pixel/layout/tooltip QA.
- Client input editing and template expansion were not driven through a graphical UI. Tests inspect the template and send the expected numeric submission through the protocol.
- No production-scale TPS/soak benchmark, packet fuzzing, or exhaustive NBT/codec boundary testing.
- No compatibility claim for later Minecraft versions, Paper/Fabric forks, or proxies.
- No exhaustive crash/persistence/reconnect matrix; online reload invalidation is covered.
- GitHub-hosted CI has run after publication. Supplied workflows run static/unit/package checks, **not** the vanilla integration suite.

## Static checks and release tests

From the repository root, with Python 3.11+:

```bash
python tools/lint.py
python -m unittest discover -s tests/unit -v
python tools/build.py
```

These commands need no third-party Python packages. The production ZIP excludes fixtures, test clients, CI files, and contributor documentation.

## Local integration procedure

Use a disposable world. The suite changes state and performs `/reload`; never run it against a production server.

1. Obtain a vanilla 1.21.6 server and Java 21. Review and accept Mojang's EULA yourself.
2. Copy this pack to `world/datapacks/Modalith` and the fixture pack `tests/fixtures/hooks` to `world/datapacks/mdl_test_hooks`. **Do not install the fixture pack in production.**
3. Bind the test server/RCON to localhost, use game port 25565 and RCON port 25575. Enable RCON and set a test-only password. The default expected password is `local-test-only`; an environment override is supported.
4. Use an isolated offline-mode server for these synthetic clients. Do not grant either test player OP. Keep other players out of the test world.
5. Install Python test dependencies: `pip install -r tests/requirements.txt`.
6. Install Node dependencies: `npm ci --prefix tests`. Node 22+ is recommended.
7. Start the server, then run `node tests/clients.js`. Both `Tester` and `Other` should log in. The driver listens only on localhost port 25581 and writes `packets.jsonl` in the working directory.
8. Run `python tests/integration.py`. A nonzero exit code means at least one assertion failed; unexpected exceptions also fail the run. Results are written to `TEST_RESULTS.json` in the working directory.
9. Stop both clients/server afterward. Keep world data, server credentials, downloaded binaries, and raw logs out of the repository.

The suite assumes the first two assigned library IDs are 1 and 2 and that the fixtures are installed. Use a clean world or adjust the helper IDs. Configuration overrides are `MDL_RCON_HOST`, `MDL_RCON_PORT`, `MDL_RCON_PASSWORD`, and `MDL_CLIENT_PORT`; the client driver supports the same client port and `MDL_GAME_PORT`. Do not expose this control driver publicly.

## Test implementation notes

The driver paces player commands to avoid vanilla's command spam disconnect. RCON output can truncate large NBT dumps, so tests query individual frame fields rather than dumping the complete catalog. Some modern SNBT escapes are not supported by `nbtlib`; the escaping regression uses the server's own NBT-path comparison instead.

Lifecycle hooks write observer snapshots to `mdl_test:events`, allowing tests to inspect an input event even after a callback opens a new screen and replaces `mdl:event`. This is also the recommended pattern for application-side event auditing.

Large ranked-catalog test models are assembled record-by-record in fixture storage and passed with `function ... with storage`, rather than exceeding the RCON command-length limit. Synthetic clients join in a defined order to satisfy the documented player-ID fixture assumption.

## 2.0 coverage

Twenty additional vanilla assertions cover ordered typed commands, inherited/overridden payloads, nested queue and result snapshots, before/after hook observation and cancellation, 64-action and 16-chain bounds, unsupported/empty actions, five native client action codecs and no privileged tickets, refresh/close, cloned multi-action ticket dispatch from a non-OP player, and the isolated action showcase. All callback fixtures are explicitly migrated to arrays; no compatibility adapter converts strings during the tests. Runtime source is checked byte-for-byte against tested production data.
