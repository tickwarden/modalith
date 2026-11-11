# Architecture and trust model

## Persistent state and shared scratch

```text
mdl:db players.p<ID>
  frame       last successfully shown managed dialog and allowed routes/form
  view        renderer callback and payload
  catalog     current/last catalog model
  history     up to 16 renderer/payload/catalog snapshots
  wizard      example application data

mdl:templates entries.<key>  trusted reusable drafts
mdl:config                  ttl and cooldown defaults
mdl:stats snapshot          exported global/player counters

mdl:work        shared synchronous builder draft, with owner ID
mdl:ctx         current player ID and submitted ticket
mdl:event       current accepted/lifecycle event (ephemeral)
mdl:catalog     temporary pagination model/queue
mdl:nav         history scratch
mdl:template    template clone/rekey scratch
mdl:reject      rejection reason scratch
```

`mdl.id` binds scoreboard player identities to monotonically assigned IDs. Storage paths use `p1`, `p2`, etc.; player names are not interpolated into storage paths. Tickets and IDs are never intentionally recycled. New IDs stop at the signed integer ceiling; tickets stop at 200,000,000. Manual counter resets are unsafe when any old state remains.

## Render and dispatch

1. Begin deletes old draft compounds explicitly. An empty `data merge` compound does not clear existing nested fields.
2. Setters append trusted components, inputs, buttons, and callback payloads.
3. Show checks owner ID, parses/runs an inline dialog macro, and commits only after command success.
4. A committed session enables triggers, sets TTL, records a show metric, and emits the show observer.
5. Tick decreases active TTL and remaining cooldown. Submitted triggers are resolved only against that player's committed frame.
6. Gate/ticket/range validation runs first, followed by cooldown and predicate authorization.
7. A rejection increments metrics, emits its observer, resends the same frame, and rearms triggers without extending TTL.
8. Acceptance sets cooldown and metrics, consumes the session, clears the dialog, emits the accepted-event observer, then invokes the trusted callback.

A client never chooses a function name or arbitrary payload through the numeric transport. A valid ticket is not a secret and does not prove that the UI was physically clicked. Players may type their own permitted trigger manually.

## Template rekeying

Saving stores a server-side draft without binding it to its original owner. Loading starts a draft for the current player and walks its stored routes, assigns new tickets, and updates the matching action commands in regular action arrays, footer, notice, and confirmation fields. Numeric form gates and client templates are rekeyed separately with overflow checks.

Before editing a matched list element, the loader checks that the element exists. Otherwise NBT path mutation could create a phantom list element for an exit-only route and make the dialog codec reject the result. Integration tests cover this behavior.

Templates are not a raw command parser: arbitrary raw/nested commands are left untouched. Trusted keys, callbacks, pattern strings, and serialized model size remain the integrator's responsibility. Loading is synchronous and shares the same non-reentrant constraints as the builder.

## Concurrency constraints

Minecraft command chains execute synchronously. `execute as @a run function example:render` is safe if each player's full begin→show chain finishes before returning. Persistent player frames remain separate; builder, event, navigation, template, and scoreboard scratch are shared.

Do not:

- Keep a draft open across ticks or `schedule` boundaries.
- Start a second player's builder and then resume the first.
- Dispatch recursively or render inside lifecycle observers.
- Assume `mdl:event` survives a subsequent show/close/reject event.

Copy delayed work to your own player-keyed state and begin a new chain later. The show owner guard prevents cross-owner commit, not arbitrary reentrant execution.

## Permission boundaries

Predicate guards check current server state at submission. A missing predicate fails closed, including failure to instantiate the guard macro. Predicates do not turn raw commands into protected callbacks. Recheck transaction-sensitive state inside privileged business callbacks.

A shop should read current price, balance, stock, and eligibility at purchase time. A hidden button or admin-only entry screen is not sufficient authorization. Other datapacks can modify storage and scoreboard state; privileged server code is outside this library's trust boundary.

Cooldown is per-player callback pacing, not anti-DDoS protection. The public opener and raw APIs bypass callback pacing. There is no automatic rollback or crash-safe financial transaction system.

## Lifecycle and persistence

TTL defaults to 1200 online ticks. `pause:false` keeps the integrated server ticking. The leave-game statistic detects reconnects; load increments an epoch so players who were offline during reload invalidate stale sessions when they return. Online reload invalidates immediately.

`on_close` covers explicit managed close and timeout's close phase, not every replacement/consumed session. Timeout emits `on_timeout` before close. Hook code is observer-only and must not start builders.

Cooldown and metrics survive ordinary reload. Templates survive reload until deleted. History and wizard data survive close. Old player data and templates are not garbage-collected. Crash rollback follows ordinary world persistence; monotonic counters do not constitute crash-proof transactions.

## Resource costs

- Tick work filters online players and updates active sessions/cooldowns; it does not scan catalog models every tick.
- Catalog rendering costs roughly `page * size + size`: it removes skipped items from a scratch queue.
- Catalogs may be copied into a frame, persistent model, and history snapshots. Large models increase RAM, disk, command-chain, and packet costs.
- History depth is 16; page size is 1–27. The demo generates 80 items. These are library defaults/limits, not bypasses of Mojang limits.
- Templates store full drafts and rekey routes linearly. Avoid huge unbounded template registries.
- Metrics use signed scoreboard integers and can eventually wrap. Export/reset them through an application retention policy if needed.

## Compatibility and removal

Public interfaces are `mdl:api/*`, documented storage/objectives, and observer tags. `internal/*` and scratch layouts may change between minor versions. Version 1.1 preserves the old API and adds defaults on load; observer event scratch now resets between event types, and click events no longer expose a stale form value.

For removal, close active dialogs first, remove the pack, then delete the `mdl.*` objectives and `mdl:*` storage data only if you no longer need them. No automatic uninstall or general migration framework is included.


## Version 1.2 progress and live-view internals

`mdl:progress` is a bounded synchronous component builder. The numerator is clamped before calculating segment fill and percentage, with max capped at one million; at most 64 loop iterations append complete component compounds. `progress_style` lives in the draft/frame and is copied by templates. Serialized bodies are immutable snapshots until a renderer builds them again.

Auto-refresh stores its interval/countdown in per-player objectives. The draft's `refresh.interval` is committed with the frame and copied by templates. Tick updates countdowns, handles expiration and submissions, then runs due renderers. A temporary `mdl.refreshing` tag tells managed show not to refill TTL. Successful show marks `mdl.refresh_done`; otherwise the timer stays off. These tags are internal and must not be manipulated by integrations.

Input dialogs are rejected both at configuration and at show time. Successful refresh uses the normal builder/ticket/show metrics path. Recovery resends after rejected submissions still do not count as shows or extend TTL. Renderers must avoid history pushes and business side effects because automatic dispatch is not an accepted player event.

The added two score updates and due-renderer selectors scale with online active views, but each actual render creates a new dialog packet and new tickets. Keep intervals conservative and model sizes bounded. There is no graphical tweening, incremental client patching, offline timer execution, or universal client-dismiss notification.


## Version 1.3 extension state

Global trusted registries: `mdl:themes entries.<key>` and `mdl:translations entries.<locale>.<key>`. Themes are copied into `mdl:work theme` and frame/template snapshots; later registry edits do not retroactively restyle existing frames. Locale lookup uses `players.p<ID>.locale`, then `mdl:config fallback_locale`, then an explicit missing marker. No client-language detection or arbitrary template evaluation is added.

Player compound state lives in `players.p<ID>.state`. State getters clear the shared output and set `mdl:state found`, distinguishing an empty compound from a missing key. State/locale and notification fields are initialized lazily, so existing players need no destructive migration. `forget` still resets the player's entire library record.

Notifications use a per-player `notifications` list, `notify_open` flag and `notify_return` renderer snapshot. Starting display saves the prior renderer once; acknowledgement pops the first item. Final acknowledgement closes the notice and invokes the saved renderer. Queue-specific frame markers are not reusable template state. Background queue clearing does not close unrelated UI. There is no automatic expiry, toast overlay, offline delivery process or general modal stack.

Numeric rules run after gate/range transport validation but before cooldown/predicate authorization and acceptance. Step/offset arithmetic and a bounded compound-list membership test operate on the decoded numeric code; they do not decode arbitrary text or every packed field. Business rules still belong in callbacks.

Rank sorting uses a stable selection pass with a copied scan queue. Missing ranks are zero, strict comparisons preserve tie order, and at most 64 items are accepted. Cost is quadratic; the bound is deliberate to stay within practical synchronous command budgets. It is not suitable for repeatedly sorting huge catalogs in a short live-refresh interval.

The extra helpers still share synchronous scratch. Observers must not open builders, queue displays or nested dispatch chains. Trusted keys are interpolated as NBT paths and are not a sandboxed public user-key API.

## 2.0 action dispatch

`internal/callback` snapshots a typed callback array and shared payload into `mdl:dispatch stack`. Each entry is removed before execution, with up to 64 entries and 16 nested frames. The current frame survives renderer reentrancy. Action metadata lives in `mdl:action`; cancellable before/after hooks surround server dispatch only. Native client buttons are not privileged routes. See [ACTIONS.md](ACTIONS.md) for the context boundary and migration.
