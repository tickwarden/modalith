# Modalith

**Macro-native dialog library for Minecraft Java 1.21.6.**

Build dialogs at runtime, route non-OP player actions back to server functions, and keep UI state separate for every player. No mods, plugins, resource packs, or static dialog registry JSON files are required.

```mcfunction
$return run dialog show @s $(dialog)
```

The library serializes an NBT compound from storage into an inline dialog definition. It does not register new dialog IDs or bypass vanilla permissions and codecs.

**Version:** 2.0.0 · **Data pack format:** 80 · **License:** MIT
**Repository:** [tickwarden/modalith](https://github.com/tickwarden/modalith)

## Publication history

Modalith started at **1.0.0**, not 1.3.0. Versions **1.0.0, 1.1.0, and 1.2.0** were developed and packaged locally before the repository was uploaded to GitHub. The repository was first published on **November 11, 2026**, when development had already reached **1.3.0**.

The initial GitHub commit therefore imports the accumulated 1.3.0 source; it is **not the project's first development version**. Earlier development stages are documented in the [changelog](CHANGELOG.md), but their original commit-by-commit history is not present in this repository. Those entries describe pre-publication versions, not prior GitHub Releases or tags.

## New in 2.0: typed multi-action callbacks

Callbacks are now arrays of typed server actions. This is a breaking API change; migrate string callbacks before upgrading. Eight action entry points, isolated `mdl_demo` examples and cancellable per-action hooks are described in [the action and migration guide](docs/ACTIONS.md).

## New in 1.3: six runtime extensions

| Feature | What it adds |
|---|---|
| Theme registry | Register/apply reusable title, body, button and layout defaults at runtime; templates keep the selected theme. |
| Locale dictionaries | Per-player locale selection, server-owned component dictionaries, fallback lookup, and localized builder helpers. |
| Player UI state | Compound-valued set/get/remove/clear APIs outside shared event scratch, isolated by player identity. |
| Notification FIFO | Explicitly show up to 32 queued notices, acknowledge through validated routes, then restore the prior renderer. |
| Numeric form rules | Enforce a step/offset and optional allowed-value list on the server before accepting a form. |
| Ranked catalogs | Stable ascending/descending rank sorting of up to 64 items, followed by the existing pagination renderer. |

See [the six-feature tutorial and reference](docs/EXTENSIONS.md). The demo opener includes **New in 1.3 • Six extensions**. Progress bars, live views, templates, guards and all earlier APIs remain available.

## New in 1.2: progress and live views

- **Progress bars:** append a computed text-component bar with a label, percentage, current/max values, configurable segment glyphs/colors, 1–64 segments, clamping, and overflow-safe limits. No native dialog progress widget is claimed.
- **Automatic refresh:** opt in to a per-player renderer timer, with a 5–1200 tick interval, fresh tickets per render, original TTL preservation, explicit stop, and input-dialog safeguards.

```mcfunction
function mdl:api/progress_style {segments:20,width:300,filled:{text:"|",color:"aqua"},empty:{text:"|",color:"dark_gray"}}
function mdl:api/progress {label:{text:"Download"},value:65,max:100}
# To update live, define a pure renderer and opt in before every show:
function mdl:api/view {callback:[{type:"function",function:"example:render_status"}],payload:{}}
function mdl:api/auto_refresh {ticks:20}
```

See [the complete live progress tutorial](docs/PROGRESS.md). The public demo includes **New in 1.2 • Live progress**.

## New in 1.1: five features

| Feature | What it does |
|---|---|
| Runtime templates | Save a complete draft in storage, then instantiate it for any player with fresh route and form tickets. Supports regular, notice, and confirmation dialogs. |
| Predicate guards | Re-evaluate a server predicate immediately before accepting a button or numeric form. Missing predicates fail closed. |
| Callback cooldowns | Enforce a configurable per-player delay between accepted callbacks. Rejected actions preserve the session and do not extend its TTL. |
| Lifecycle hooks | Observe show, explicit close, timeout, and rejection events through function tags, in addition to the existing accepted-event hook. |
| Usage metrics | Track per-player and global shown, accepted, rejected, and expired counts; export snapshots to storage. |

All demo UI, documentation, and contributor-facing text is in English.

## Existing capabilities

- Runtime NBT builder with compound text components and item bodies.
- Non-OP `/trigger` callback transport; trusted payloads remain server-side.
- Per-player sessions, one-use tickets, stale/cross-player ticket rejection.
- Dynamic catalogs, pagination, renderer-based history, and refresh.
- Text, boolean, single-option, and number-range controls.
- Validated numeric forms, atomic fixed-width multi-field packing, and wizards.
- Native notice and confirmation builders; raw inline escape hatches.
- TTL, reconnect invalidation, and reload epochs.

## Install

1. Build or download `modalith-2.0.0-mc1.21.6.zip`.
2. Copy it to `<world>/datapacks/`. The ZIP contains `pack.mcmeta` at its root.
3. Run `/reload`.
4. As a player, run `/trigger mdl.open`. OP is not required.

Administrator alternative:

```mcfunction
execute as <player> at @s run function mdl_demo:demo/home
```

The home screen links directly to **2.0 • Typed actions + hooks**. See the [example walkthrough](docs/EXAMPLES.md) for native buttons, ordered callbacks and the optional hook companion pack.

The demo opener is public. Replace its routing in `tick.mcfunction` before deploying a private/admin UI. Recheck permissions in privileged callbacks.

## Quick start

In your own pack, create `data/example/function/menu.mcfunction`:

```mcfunction
function mdl:api/begin
function mdl:api/title {text:{text:"Quests",color:"gold",bold:true}}
function mdl:api/body {text:{text:"Choose your next adventure.",color:"gray"},width:300}
function mdl:api/view {callback:[{type:"function",function:"example:menu"}],payload:{}}
function mdl:api/button {label:{text:"Forest expedition"},callback:[{type:"function",function:"example:accept"}],payload:{quest:7}}
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
function mdl:api/show
```

Create `data/example/function/accept.mcfunction`:

```mcfunction
# @s is the player who submitted the ticket. Recheck quest eligibility here.
$scoreboard players set @s quest.id $(quest)
tellraw @s {text:"Quest accepted!",color:"green"}
```

Create `quest.id` in your own load function, then open the UI with:

```mcfunction
execute as @a[tag=quest_menu] at @s run function example:menu
```

Finish each player's complete `begin → show` chain synchronously. Shared builder scratch is not reentrant and must not be kept across ticks.

## Template example

```mcfunction
# Save after building the draft, before showing it:
function mdl:api/template_save {key:"quest_menu"}

# Later, as any player:
function mdl:api/template_load {key:"quest_menu"}
# Optionally customize the cloned draft:
function mdl:api/title {text:{text:"Your quests",color:"aqua"}}
function mdl:api/show
```

Templates are trusted server-owned data, not untrusted user input. Check return values when loading a potentially missing template. Every load reissues tickets; raw custom commands are not rewritten.

## Configuration

```mcfunction
data modify storage mdl:config ttl set value 1200
data modify storage mdl:config cooldown set value 4
```

TTL is measured in online ticks. Cooldown is clamped to 0–1200 ticks when applied. A value of zero disables callback throttling. This is not a network-level anti-spam system.

## Documentation

- [API reference](docs/API.md)
- [Architecture and security model](docs/ARCHITECTURE.md)
- [Research and vanilla limits](docs/RESEARCH.md)
- [Testing and reproducibility](docs/TESTING.md)
- [Publishing under tickwarden](docs/PUBLISHING.md)
- [Changelog](CHANGELOG.md)
- [Security policy](SECURITY.md)

## Build and checks

Python 3.11+; no Python dependencies are needed for static checks and packaging.

```bash
python tools/lint.py
python -m unittest discover -s tests/unit -v
python tools/build.py
```

Artifacts are written to `artifacts/`, including SHA-256 checksums. GitHub Actions validates and packages pushes/PRs; version tags can create a release after publication. Vanilla integration tests are a separate, manual procedure requiring a local server and test clients. See [testing](docs/TESTING.md).

## Honest limits

Arbitrary text capture from non-OP players is **not** implemented as a generic vanilla callback. `dynamic/custom` sends a client packet, but vanilla does not expose that packet as a datapack event. The text-input demo is UI-only; validated numeric codes and server-owned button payloads are the supported transport.

Macros do not remove dialog width/layout limits, packet limits, command-chain limits, or permission requirements. A valid ticket proves only that a player submitted an allowed action for their active session—not that a physical button was clicked. Recheck permissions, balances, stock, and state at the point of use.

**Compatibility:** Minecraft Java 1.21.6 only. Later versions, forks, and proxies need independent testing. This project is not affiliated with Mojang or Microsoft.
