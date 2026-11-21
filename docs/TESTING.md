# Current verification: 2.5.0

- Official vanilla Minecraft 26.3 / Java 25: **212/212** RCON/API/codec checks
  (88 prior regressions plus 124 new-feature checks).
- Python: **32/32** offline unit tests; lint: **262 functions, 0 errors**.
- Installed runtime data and pack metadata match source byte-for-byte; no function
  load errors. Core/demo archive layout, reproducibility and checksums verified.
- No player clients (human or synthetic) were connected. No graphical, player-session,
  end-to-end trigger or DDoS test is claimed. Begin/template default-width wiring has
  structural unit coverage, not live player-session coverage.
- Current results: `TEST_RESULTS.json` and `tests/run-metadata.json`.
  The sandbox clock differs from the session date; metadata preserves it as an
  explicitly labeled environment reading, not an asserted wall-clock timestamp.
  Prior evidence remains under `tests/history/2.4.0/` and earlier history directories.

## Isolated live-test harness

The 2.5 run used a separate Linux network namespace with **only loopback**, no external
interface, a namespace different from the launching environment, and no game clients.
This replaces the shared hosted networking used in the previous run. Java was stopped
in the harness cleanup; test credentials/world/runtime are not release artifacts.

On a Linux machine where namespace creation is permitted, prepare a new disposable
runtime as documented below, review official downloads and accept the EULA explicitly.
Then, adapting the local user/interpreter paths as necessary:

```sh
sudo env MDL_HOST_NETNS="$(readlink /proc/self/ns/net)" unshare -n sh -c \
  'ip link set lo up; exec runuser -u user -- /usr/local/bin/python tests/run_isolated.py /absolute/runtime'
```

The harness verifies loopback-only interfaces and a changed namespace **before** Java
starts, then executes both server suites and stops Java in `finally`. It does not
create/download a server, accept an EULA, configure a firewall or make a namespace
safe by itself. Missing prerequisites fail closed. It needs Linux `ip`, `unshare`,
`runuser`, Python test dependencies and Java 25 in the prepared runtime. The normal
RCON test preflight remains active. Do not add veth interfaces, proxies or forwarding.
The host administrator can still inspect/control a namespace: this is not protection
against a hostile hosting provider or an IP anonymity/DDoS guarantee.

## Previous 2.4 verification and preparation policy (historical evidence)

# Current verification: 2.4.0

- Official vanilla Minecraft 26.3, Java 25: **88/88** RCON/API/codec checks.
- Python: **24/24** offline unit tests; lint: **241 functions, 0 errors**.
- No human or synthetic game clients were connected in this run. No graphical,
  player-session, end-to-end trigger, or DDoS test is claimed.
- Previous evidence is preserved under `tests/history/2.3.0/`.
- Results: `TEST_RESULTS.json` and `tests/run-metadata.json`.

## Fail-closed local test policy

Prepare a new disposable directory with `python tests/prepare_local_server.py DIR`.
Review its files; obtain the official server and explicitly accept its EULA yourself.
Never use real player data, unknown servers, public hosts, tunnels or port forwarding.
Use an actually isolated local environment, not an exposed hosted preview.
Server preparation does not download, run or accept the EULA.

Both Python RCON entrypoints and `tests/clients.js` require
`MDL_LOCAL_TEST_ACK=1` and `MDL_TEST_SERVER_DIR=DIR`. Destinations must be numeric
loopback addresses matching the prepared settings. DNS, public/private remote,
wildcard and metadata destinations fail before connection. Status/query must be off,
whitelist must contain only the two documented synthetic identities, and ops empty.
The Node controller binds loopback; dialog capture requires `MDL_CAPTURE_DIALOGS=1`.
Synthetic clients are test automation, never evidence of human activity.

These checks inspect configuration, not running-process provenance, network namespaces,
plugins, firewall rules or platform routing. Localhost binding alone is insufficient:
this hosted run exposed separate platform forwarding listeners, despite loopback-bound
Java listeners. The server was stopped after checks. No public accessibility test or
network isolation guarantee is asserted. Do not repeat tests where forwarding is enabled.
This tooling provides neither IP anonymity nor DDoS protection. Do not publish raw logs,
credentials, captures or world data. `log-ips=false` is only one setting, not a universal
log scrubber. The fixed local test RCON password is never suitable for an exposed server.

## Historical test documentation (not current evidence)

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
