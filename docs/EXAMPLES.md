# Updated 2.0 examples

Install the separate `modalith-demo-2.1.0-mc1.21.6.zip` alongside the core before using these examples. Source: `mdl_demo`. The core ZIP contains no demos or public demo opener.

All runtime examples use **`mdl_demo`**, not the core `mdl` namespace. All callback fields are typed arrays. Existing core APIs still live in `mdl`.

## Start here

```mcfunction
# Run as a player, or use /trigger mdl.open without OP.
function mdl_demo:demo/home
# Open the 2.0 showcase directly:
function mdl_demo:demo/actions
```

The home menu links directly to **2.0 • Typed actions + hooks**. The showcase provides native URL, suggested command, clipboard, nested notice and client command buttons, plus one ordered server chain. Native actions are client-side and do not emit server action hooks.

## Three ordered effects from one validated button

The showcase uses:

```mcfunction
function mdl:api/button {label:{text:"Save state → sound → refresh"},callback:[{type:"function",function:"mdl:api/state_set",payload:{key:"action_demo",value:{clicked:1b}}},{type:"run_command",cmd:"playsound minecraft:entity.experience_orb.pickup player @s ~ ~ ~ 0.5 1"},{type:"refresh"}],payload:{}}
```

1. Save a compound in this player's state, using an explicit action-specific payload.
2. Play a sound for that player, using the trusted server `run_command` macro.
3. Rebuild the saved renderer with `refresh`.

The chain is not atomic. A failed/cancelled action does not prevent later entries from running. The demo avoids broadcast messages or inventory/currency grants.

Inspect the saved example state as the same player:

```mcfunction
function mdl:api/state_get {key:"action_demo"}
data get storage mdl:state result
```

The showcase also has separate **Home** and **Close** controls. Close uses `callback:[{type:"close"}]`; the live-data demo uses `callback:[{type:"refresh"}]` rather than wrapping the corresponding API in a function action.

## Optional hook companion pack

`examples/action_hooks` is a separate, installable source datapack. Copy that directory to your world's `datapacks` directory alongside Modalith and run `/reload`. Its `pack.mcmeta` must be at the companion pack root. **It is not bundled or automatically enabled in the main production ZIP.**

It registers:

- `mdl_example:before_action` in `#mdl:before_action`: cancels only server `run_command` entries for players tagged `mdl_example.block_commands`.
- `mdl_example:after_action` in `#mdl:after_action`: copies action metadata into that player's `last_action` state record, so nested callbacks or later events cannot overwrite the saved observation.

Try cancellation:

```mcfunction
tag @s add mdl_example.block_commands
function mdl_demo:demo/actions
# Click Save state → sound → refresh. State save and refresh still run; sound is cancelled.
```

Inspect the last observed action:

```mcfunction
function mdl:api/state_get {key:"last_action"}
data get storage mdl:state result
```

The final observation is normally the refresh action, not the earlier cancelled sound action: this example stores only the most recent entry, not a complete audit log. Remove the test tag with `tag @s remove mdl_example.block_commands`. Remove the companion pack and reload to disable these example observers.

The hooks are illustrative trusted server code, not an authorization system. Use real permission and business-state checks for sensitive operations. Do not recursively invoke `api/actions` from `before_action`.

## Other demos

| Function | Demonstrates |
|---|---|
| `mdl_demo:demo/catalog` | Dynamic pagination and trusted item payloads |
| `mdl_demo:demo/wizard` | Validated numeric input across steps |
| `mdl_demo:demo/confirm` | Single-use confirmation routes |
| `mdl_demo:demo/inputs` | Native input control codecs |
| `mdl_demo:demo/live` | Server data resolution and typed refresh |
| `mdl_demo:demo/packed` | Atomic packed numeric submissions |
| `mdl_demo:demo/features` | Guards, metrics and runtime templates |
| `mdl_demo:demo/progress` | Text progress bars and timed renderer refresh |
| `mdl_demo:demo/extended` | Themes, locales, state, notifications, rules and sorting |

See [ACTIONS.md](ACTIONS.md) for the complete type/context table, nesting limits and 1.x migration. The optional companion examples have static/layout coverage; no new vanilla integration run is claimed for this example-only update.

## Configurable button widths

```mcfunction
function mdl:action/open_url {label:{text:"Documentation"},url:"https://github.com/tickwarden/modalith"}
function mdl:api/button_width {width:220}
function mdl:api/button {label:{text:"Refresh"},callback:[{type:"refresh"}],payload:{}}
function mdl:api/button_width {width:180}
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
function mdl:api/exit_width {width:220}
function mdl:api/show
```

`button_width` overrides the most recently appended action button, whether native, routed, raw or a numeric form submit button. Call it **after** adding that button and **before** `show`. For notice/confirmation conversion, call it before `notice` or `confirmation`. `exit_width` affects only the existing multi-action exit button. Both require an NBT **int** in `1..1024`, return 1 on success or 0 for an invalid width/missing target, and leave the button unchanged on failure. The explicit setter overrides the theme width for that button. Other buttons keep their original theme/default widths. Existing builder signatures are unchanged.
