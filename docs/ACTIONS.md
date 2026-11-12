# Typed actions and migration to 2.0

## Two execution contexts

A **server callback** is an ordered array of typed objects. A **native client action** is a single Minecraft dialog button action. Vanilla does not provide a way to execute several client actions from one button; opening a URL from a server function is not supported. Modalith deliberately keeps these contexts distinct.

The eight new `mdl:action/*` entry points are `run_command`, `open_url`, `suggest_command`, `copy_to_clipboard`, `show_dialog`, `function`, `close`, and `refresh`.

## Ordered server chains

```mcfunction
function mdl:api/button {label:{text:"Purchase and redraw"},callback:[{type:"function",function:"shop:purchase",payload:{sku:12}},{type:"run_command",cmd:"say Purchase action finished"},{type:"refresh"}],payload:{}}
```

Supported callback objects:

| Type | Fields | Behavior |
|---|---|---|
| `function` | `function:"namespace:path"`, optional `payload:{}` | Calls a trusted server function with compound macro arguments. |
| `run_command` | `cmd:"scoreboard players add @s coins 1"` | Runs a trusted command as the submitting player, at the function execution permission level. No leading slash. |
| `close` | none | Clears and invalidates the current managed dialog. |
| `refresh` | none | Runs the current saved renderer. |

The low-level `mdl:action/run_command` implementation is exactly `$$(cmd)`: the first `$` marks a function macro line, while `$(cmd)` is the command substitution. Do not put player-supplied strings into it.

All existing routed builders accept arrays: button, guarded_button, exit, view, form_digit, form_code, localized_button, and catalog item callbacks. Shared route `payload:{}` remains required. A function action inherits it unless the object supplies its own compound `payload`.

For direct trusted server dispatch:

```mcfunction
function mdl:api/actions {callback:[{type:"run_command",cmd:"say First"},{type:"run_command",cmd:"say Second"}],payload:{}}
```

`mdl:action/function {function:"example:handler",payload:{}}`, `mdl:action/run_command {cmd:"say Hello"}`, `mdl:action/close`, and `mdl:action/refresh` are also callable directly. **Direct low-level calls do not pass through the per-action dispatcher hooks.** Use `api/actions` or a routed callback for hooks.

### Ordering, nesting and bounds

- Entries execute synchronously in list order; an empty array is a no-op.
- Up to **64 entries** execute per chain. Further entries are not run.
- Nested dispatch is limited to **16 active chains**. A dispatch at the depth limit returns zero without executing.
- A stack snapshots pending entries and shared payload. A nested renderer/chain cannot overwrite the parent's remaining queue.
- Failure or an unsupported type produces result zero and does **not** stop subsequent entries unless that entry opts into `stop_on_failure:1b` (2.1). The chain is **not atomic** and provides no rollback or success-based branching. `api/actions` reports zero for an explicitly stopped chain or an execution bound, otherwise completion rather than business success.
- Rendering, close and refresh are ordinary ordered effects. If several actions render screens, the last screen wins. Prefer a single final renderer.
- Accepted click/form routes are ticket/guard/range/cooldown validated once and consumed before dispatch, as before. Each privileged business operation must still recheck its own permission/state.

## Native client buttons

These append a native action button to the current draft; call `mdl:api/show` afterward:

```mcfunction
function mdl:action/open_url {label:{text:"Website"},url:"https://example.com"}
function mdl:action/suggest_command {label:{text:"Suggest help"},command:"/help"}
function mdl:action/copy_to_clipboard {label:{text:"Copy"},value:"Modalith"}
function mdl:action/show_dialog {label:{text:"Notice"},dialog:{type:"minecraft:notice",title:{text:"Hello"},action:{label:{text:"OK"}}}}
function mdl:api/action/run_command {label:{text:"Client help"},cmd:"/help"}
```

`mdl:action/run_command` is the **server macro**; `mdl:api/action/run_command` builds a **client** command button. Native client commands retain the player's permissions. Native actions do not allocate privileged route tickets, emit server acknowledgement hooks, or claim to notify the server that a URL was opened. Client URL security prompts still apply.

Convenience string wrappers interpolate trusted strings into SNBT quotes. For arbitrary quotes, backslashes or rich/nested action data, pass the complete compound through the serializer-safe generic builder instead:

```mcfunction
function mdl:api/action/native {label:{text:"Copy quoted text"},action:{type:"minecraft:copy_to_clipboard",value:'He said "Hello"'}}
```

Native open_url/suggest/copy/show_dialog helpers inherit the active button theme. The generic native builder and native run_command builder use width 150 without theme merging. A raw native button is not a routed callback; server session bookkeeping may remain active until close, timeout or another managed action.

## Improved hooks

Existing `#mdl:on_event`, `on_show`, `on_close`, `on_timeout` and `on_reject` remain available. New empty production tags are:

- **`#mdl:before_action`** — runs before each dispatched server action. Set `storage mdl:action cancelled` to **`1b`** to skip that entry.
- **`#mdl:after_action`** — runs after execution or cancellation, including unsupported types.

Action scratch at `storage mdl:action`:

| Field | Meaning |
|---|---|
| `action` | Trusted queued object (restored before execution and after nested dispatch). |
| `payload` | Effective payload, including any per-action override. |
| `index` | Zero-based position in this chain. |
| `cancelled` | `0b` or `1b`; cancellation affects only this entry, not the rest of the chain. |
| `result` | Integer command/function result after execution; zero for cancelled/unsupported actions. |

Player UUID and numeric ID are refreshed in `mdl:event player` and `player_id` before both hooks. `mdl:event` lifecycle data and `mdl:action` are transient scratch, not an event log; copy needed data inside your observer. Hook order follows normal function tag ordering. Observers are trusted server code; they must not edit the internal dispatch stack, reload the pack mid-chain, or recursively dispatch from `before_action`. Hooks are not a security sandbox. Cancellation is a convenient integration gate, not a replacement for transaction checks.

Register hooks from your own datapack using `data/mdl/tags/function/before_action.json` and `after_action.json` with `{"values":["yourpack:observe_action"]}`. Leave `replace` unset so other integrations remain registered.

## Migration checklist

1. Change `callback:"example:handler"` to `callback:[{type:"function",function:"example:handler"}]`. Keep the existing route payload.
2. Apply this to stored catalog models and view/form builders, not just buttons. String callback compatibility is intentionally not retained.
3. Rebuild saved runtime templates and persisted renderers created with 1.x. Old stored callback strings and old demo function IDs are not automatically converted. Back up storage before upgrading.
4. Replace `mdl:demo/*` with **`mdl_demo:demo/*`**, `mdl:test/*` with `mdl_demo:test/*`, and the example predicate with `mdl_demo:demo_allowed`.
5. Update observers that assumed `mdl:event route.callback` was a string. Numeric validation and ticket semantics remain unchanged.

Examples and codec demonstrations now live entirely under `data/mdl_demo`. The core still exposes its existing public `mdl.open` trigger as a bridge to the demo home; replace/disable that opener for private integration. The action showcase is `function mdl_demo:demo/actions`, also linked from the Features demo.

See [the 2.1 runtime guide](RUNTIME_FEATURES.md) for `delay`, `conditional`, stop-on-failure and button disable APIs.
