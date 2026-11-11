# API reference — 1.3.0

## Conventions

All builder calls execute **as a player**, in one synchronous `begin → setters → show` chain.

- `text`, `title`, and `label`: use compound text components, e.g. `{text:"Hello"}`. Do not supply bare strings to these macro parameters.
- `payload`, `input`, `item`, and `button`: NBT compounds.
- `callback`: a trusted function resource location, never user-supplied text.
- `guard`: a trusted predicate resource location, evaluated with the player as `this` at their current location.
- `key` for templates: a trusted simple identifier such as `quest_card`, conventionally `[a-z0-9_]+`. This is a developer API, not a sandboxed parser for untrusted keys.
- Component compounds are serialized as complete SNBT values, preserving quotes, backslashes, newlines, and literal `$()` text.

## Core builder

| Function | Arguments / behavior |
|---|---|
| `mdl:api/begin` | Creates a default multi-action draft for `@s`. Does not consume the current session until `show` commits. |
| `mdl:api/title` | `{text:{text:"Title",color:"gold"}}` |
| `mdl:api/body` | `{text:{text:"Message"},width:300}`; appends a plain-message body. |
| `mdl:api/item` | `{item:{id:"minecraft:diamond",count:1},text:{text:"Diamond"}}` |
| `mdl:api/options` | `{columns:2,escape:1b}` |
| `mdl:api/input` | `{input:{type:"minecraft:boolean",key:"value",label:"Enabled"}}` |
| `mdl:api/button` | `{label:{text:"Choose"},callback:"example:choose",payload:{id:4}}` |
| `mdl:api/exit` | Same parameters; creates the footer/Escape action. |
| `mdl:api/raw_button` | `{button:{label:{text:"Copy"},action:{type:"minecraft:copy_to_clipboard",value:"ABC"}}}` |
| `mdl:api/view` | `{callback:"example:render",payload:{tab:2}}`; defines the renderer for back/refresh. |
| `mdl:api/notice` | Moves the first button into a native notice footer. Create at least one button first. |
| `mdl:api/confirmation` | Moves the first two buttons into native yes/no fields. Escape invokes no. |
| `mdl:api/show` | Renders the inline compound, then commits on success; returns 1 on success, 0 on guarded failure. |
| `mdl:api/close` | Clears the UI and invalidates triggers/session. Emits `on_close` only if a library session was active. |
| `mdl:api/forget` | Closes and resets the player's library state; does not recycle the scoreboard ID or reset metrics. |

Defaults: `pause:false`, `after_action:"wait_for_response"`, Escape enabled, two columns. For a raw action that will not receive a server reply, change `mdl:work dialog.after_action` to `"close"`. An empty multi-action draft gets a fallback button that returns to the public demo opener; production UIs should provide their own actions.

Call notice/confirmation conversion after all buttons and before show. Do not add ordinary buttons afterward. Extra routes remain in the server allowlist even if no longer visible; never use visibility as authorization.

## Callback contract

```mcfunction
function mdl:api/button {label:{text:"Buy"},callback:"shop:purchase",payload:{sku:12}}
```

The router invokes `function shop:purchase {sku:12}` as the submitting player with server-function permission. The client sends only a numeric ticket, not the callback name or payload. The session is consumed and the UI cleared before accepted-event hooks and the callback execute.

During `#mdl:on_event`, `storage mdl:event` contains:

- `type`: `"click"` or `"input"`.
- `player`: UUID int array; `player_id`: internal ID.
- `route`: trusted callback/payload/ticket, plus guard or form metadata where applicable.
- `value`: decoded integer for input events; absent for clicks.

This is shared scratch. A subsequent lifecycle event, including `show`, replaces its fields. Copy data during the hook if you need persistent event history. Callbacks must not expect accepted-event fields to survive opening another UI.

## Navigation and catalogs

```mcfunction
function mdl:api/push
function example:submenu
# A routed callback may call:
function mdl:api/back
function mdl:api/refresh
```

`push` stores the current renderer, payload, and catalog snapshot. History depth is 16. `back` re-renders with fresh tickets, rather than restoring old commands. Renderers must not push history on every refresh.

```mcfunction
function mdl:api/catalog {title:{text:"Quests"},size:8,page:0,items:[{label:{text:"Forest"},callback:"example:choose",payload:{id:1}}]}
```

For large models, construct a compound in your storage and call `function mdl:api/catalog with storage example:ui args`. Size must be 1–27; page is zero-based and clamped. Item parameters match `api/button`. Previous/next controls are added automatically; the layout uses two columns. Empty catalogs remain closable. Selection submenus preserve the current catalog; history can restore nested catalog snapshots.

## Numeric forms

### One digit

```mcfunction
function mdl:api/begin
function mdl:api/input {input:{type:"minecraft:number_range",key:"value",label:"Level",start:0,end:9,step:1,initial:5}}
function mdl:api/form_digit {label:{text:"Save"},callback:"example:save",payload:{setting:1},min:0,max:9}
function mdl:api/show
```

The input key must be `value`, and its substitution must output one decimal digit. For boolean controls use `on_true:"1"` and `on_false:"0"`; for single-option controls use IDs `"0"`–`"9"`. The callback receives the decoded value through `mdl:event value` until the next lifecycle event.

### Atomic multi-field codes

```mcfunction
function mdl:api/form_code {label:{text:"Save"},callback:"example:save_many",payload:{},min:0,max:999,digits:3,pattern:"$(power)$(enabled)$(mode)"}
```

Create the referenced inputs first. Each should output exactly one digit; this example encodes `7`, `1`, `2` as `712`. Leading zeroes are interpreted through the fixed number of positions, not as persistent string formatting.

The client template becomes `/trigger mdl.input set <ticket>$(power)$(enabled)$(mode)`. Server decoding uses:

```text
factor = 10^digits
received_gate = received_integer / factor
code = received_integer % factor
```

The gate must match the active form ticket and code must be in min/max. One to six decimal positions are supported, subject to the signed 32-bit trigger value. The larger the ticket counter, the fewer positions fit; the API refuses overflow rather than recycling tickets. The global ticket ceiling is 200,000,000.

**Validate each field in the callback**, not just the combined range. The demo checks the boolean and choice positions separately. One form receiver exists per frame. Arbitrary text, negative/decimal numbers, and unlimited bit packing are not supported by this transport. Use server-owned payloads or multi-step wizards for larger data.

## New feature 1: runtime template registry

| Function | Arguments |
|---|---|
| `mdl:api/template_save` | `{key:"quest_card"}`; copies the current owned draft; returns 1 on success. |
| `mdl:api/template_load` | `{key:"quest_card"}`; clones into a draft owned by `@s`; returns 1 on success or 0 on missing template/exhaustion. Does not call show. |
| `mdl:api/template_delete` | `{key:"quest_card"}`; removes the stored template. |

Templates live in `storage mdl:templates entries.<key>` and survive reload. Save complete drafts before showing them. Each load reissues all routed tickets and the numeric form gate, including native notice/confirmation/footer commands. Arbitrary raw commands, nested raw `show_dialog` structures, and external trigger commands are not rewritten.

```mcfunction
execute store result score #loaded example.tmp run function mdl:api/template_load {key:"quest_card"}
execute if score #loaded example.tmp matches 1 run function mdl:api/show
```

Create `example.tmp` yourself. Loading a missing template leaves the existing draft untouched; do not ignore the return value. Ticket exhaustion invalidates the partial draft's owner so it cannot be shown accidentally. Template keys and contents are trusted developer data; no user-key validation or template eviction policy is provided.

## New feature 2: predicate guards

```mcfunction
function mdl:api/guarded_button {label:{text:"Restricted action"},callback:"example:restricted",payload:{},guard:"example:can_use"}
```

The predicate is checked at submission, not just at render time. It executes with `@s` as `this` at the player's current position. A false or missing predicate denies the action without consuming the session. The original committed screen is resent and the trigger rearmed. Undefined/missing predicates fail closed; malformed trusted resource-location syntax is a developer error.

To guard a form, call this **after** `form_digit` or `form_code` and before showing:

```mcfunction
function mdl:api/form_guard {guard:"example:can_use"}
```

This API does not automatically guard every raw command. Keep checks for stock, balance, and state changes inside the privileged callback, too. `mdl:demo_allowed` is an example predicate requiring the player tag `mdl.demo.allowed`.

## New feature 3: callback cooldowns

```mcfunction
# Delay applied after each accepted callback:
data modify storage mdl:config cooldown set value 4
# Override the remaining delay for the current player:
function mdl:api/cooldown {ticks:20}
```

Values are clamped to 0–1200. Cooldown decreases while online, independently of UI TTL, and applies to both routed buttons and numeric forms. Guard/cooldown denial preserves the session and resends its current screen **without extending TTL**, issuing tickets, or counting a new show. Invalid ticket/input submissions use the same recovery path.

Cooldown is not a network firewall, packet rate limiter, or transaction lock. `mdl.open`, raw commands, and privileged server calls are not callback-throttled. Reconnect/reload does not intentionally clear a remaining cooldown.

## New feature 4: lifecycle observer hooks

Add a tag in your pack, e.g. `data/mdl/tags/function/on_reject.json`:

```json
{"replace":false,"values":["example:audit_rejection"]}
```

| Function tag | Event fields / timing |
|---|---|
| `#mdl:on_show` | `type:"show"`; after a successful managed show and commit. |
| `#mdl:on_close` | `type:"close"`; explicit close of an active library session; timeout also leads to close. Repeated close is idempotent. |
| `#mdl:on_timeout` | `type:"timeout"`; immediately before timeout calls close. |
| `#mdl:on_reject` | `type:"reject"`, `reason`: `ticket`, `input`, `guard`, or `cooldown`; before restoring the screen. |
| `#mdl:on_event` | Existing accepted callback hook; `type:"click"` or `"input"`, route and optional value. |

All events include player UUID and internal ID. Lifecycle events clear old route/value/reason fields. A consumed callback transition, replacement show, reload, and reconnect do **not** emit `on_close`; this is deliberately an explicit-close hook, not a universal screen-destruction notification. Raw show does not emit managed hooks.

Hooks are synchronous observers: do not mutate library scratch, dispatch recursively, or open/close/build dialogs inside them. Persist information to your own storage or schedule a separate action after copying the required player-keyed state.

## New feature 5: usage metrics

```mcfunction
function mdl:api/stats
data get storage mdl:stats snapshot
function mdl:api/stats_reset
```

The snapshot has `global` and `player` compounds containing `shown`, `accepted`, `rejected`, and `expired`; `player.id` identifies `@s`. `stats_reset` clears only that player's counters; global counters remain intact. Metrics are scoreboard-backed, survive reload, and use signed 32-bit integers—not an unbounded analytics database.

- Player objectives: `mdl.shown`, `mdl.accept`, `mdl.reject`, `mdl.expire`.
- Global holders in `mdl.stat`: `#shown`, `#accepted`, `#rejected`, `#expired`.
- Successful managed shows count, including refresh/template displays. Recovery resends and raw shows do not.
- Acceptance counts after transport/guard/cooldown validation, before business logic. A callback's own rejection of a purchase does not undo acceptance.
- Rejected submissions count individually. Timeouts count separately from explicit closes.

## Raw dialogs, TTL, and cleanup

```mcfunction
function mdl:api/raw_show {dialog:{type:"minecraft:notice",title:{text:"Raw"},body:{type:"minecraft:plain_message",contents:{text:"Inline"}},pause:0b}}
data modify storage mdl:config ttl set value 1200
```

Raw show accepts all five vanilla types through the codec, including inline server-links/dialog-list definitions. It does not manage sessions, guards, hooks, cooldowns, or metrics. Close an existing routed session before replacing it with a raw screen.

TTL is measured in online ticks; reconnect/reload epochs invalidate old sessions. Close does not erase history, catalog, wizard state, metrics, or templates. `forget` resets the player's library state. There is no automatic retention/eviction job for old players or templates.


## New in 1.2: progress bars

```mcfunction
function mdl:api/progress_style {segments:20,width:300,filled:{text:"|",color:"aqua"},empty:{text:"|",color:"dark_gray"}}
function mdl:api/progress {label:{text:"Download",color:"white"},value:65,max:100}
```

`api/progress` appends a plain-message body, showing the label, segmented bar, integer percentage, and current/max values. It returns 1 on append and 0 for invalid numeric bounds. `label` is a compound text component. Values are signed integers; `max` must be 1–1,000,000. The value is clamped to 0–max **before** multiplication. Fill and percentage use integer floor division.

`api/progress_style` updates the current draft's style; it returns 0 without replacing the prior style if segments is not 1–64 or width is not 1–1024. `filled` and `empty` are compound text components, not raw strings. Defaults after begin: 20 segments, width 300, green `|` filled and dark-gray `|` empty. Styles affect subsequently appended bars, not previous bodies. Templates retain the style for future bars.

The temporary `storage mdl:progress result` exposes clamped `value`, `max`, `filled`, `segments`, and `percent` for diagnostics. It is shared scratch, not player-persistent state. Invalid requests need not replace a previous diagnostic result. Labels/captions/glyphs can wrap depending on font, UI scale, and body width. A text component is not a native progress widget, image, bossbar, or animation timeline.

## New in 1.2: automatic live-view refresh

```mcfunction
function mdl:api/view {callback:"example:render_status",payload:{}}
function mdl:api/auto_refresh {ticks:20}
function mdl:api/show
# Later, as the same player, to freeze without closing:
function mdl:api/auto_refresh_stop
```

`api/auto_refresh` configures the **current draft**, returning 1 on success, 0 on invalid configuration. Tick interval is 5–1200. Zero disables the draft setting. An explicit `view.callback` is required. Call it after the view setter and before show. The renderer must opt in again on each render; otherwise the next show stops scheduling.

Inputs are intentionally unsupported: configuration rejects a draft with any input, and show rechecks in case inputs were added afterward. This prevents a timer from repeatedly destroying in-progress user entry. Do not use live refresh on raw input screens or as a workaround for this guard.

Timers are per-player (`mdl.interval`, `mdl.refresh` scoreboard objectives), tick only for active library sessions, and run **after** input/click dispatch and the public opener. Every successful refresh re-renders the view with newly generated route tickets, emits the ordinary show hook, and increments show metrics. It does not send a client-side animation or modify an existing dialog in place.

Automatic show preserves the original remaining TTL rather than resetting it. Explicit user-driven manual navigation/refresh still uses ordinary show semantics. Close, timeout, reconnect/reload invalidation, and replacing a live view with a non-live draft stop the timer. A renderer that fails to show a replacement stops scheduling instead of retrying every tick. The previous session can remain active until close/TTL if no replacement was produced.

`api/auto_refresh_stop` disables the current player's running timer without rebuilding or closing the screen. It does not rewrite the renderer or saved template. A later manual render may opt in again. Calling `auto_refresh {ticks:0}` only changes the uncommitted draft; use stop for immediate timer control.

**Renderer contract:** pure, repeatable, synchronous begin→show; no history push, rewards, purchases, or other business side effects. Never enable this inside observer hooks. Do not nest player builders or call recursive refresh. If a delayed click targets a ticket from the previous automatic frame, it is stale and correctly rejected; choose conservative intervals for useful interaction.

Vanilla does not report every local client dismissal to datapacks. If a client closes without an exit trigger, an active timer may reopen the screen until stopped/expired. Always provide a routed exit and a sensible TTL; this is not a forced UI or proof that the screen is currently visible.


## New in 1.3: six extensions

See [EXTENSIONS.md](EXTENSIONS.md) for complete signatures, examples, persistence, bounds and interaction rules:

- `theme_register`, `theme_apply`, `themed_body`.
- `translation_register`, `locale_set`, `translate`, `localized_title`, `localized_body`, `localized_button`.
- `state_set`, `state_get`, `state_remove`, `state_clear`.
- `notify`, `notifications_show`, `notification_next`, `notifications_clear`.
- `form_rules`.
- `catalog_sorted`.

All calls require `@s` to be a player with a library ID (after join initialization or `api/begin`). Keys/locales are trusted simple `[a-z0-9_]+` identifiers, not user text. State values and text components use compounds. The new rejection reason `validation` is observable through `#mdl:on_reject` and the ordinary rejection metrics.

Notification acknowledgements use the existing route validator, one-use tickets and cooldowns. Enqueueing is explicit; it does not poll or interrupt on tick. Notification frames are excluded from template save/load to prevent cloning queue-specific acknowledgement routes. Old non-notification templates continue to load with missing new fields defaulted.
