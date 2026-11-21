# Composite widgets

The original four widgets below were introduced in 2.3. Three additional widgets
(callout, comparison and timeline) are documented in [the 2.5 guide](NINE_FEATURES.md).

These APIs build **read-only text layouts** using a single vanilla `minecraft:plain_message` body each. They do not register new widget IDs, add an image renderer, create interactive checkboxes or provide a native table/card/stepper control. They require Minecraft Java 26.3 and the normal Modalith draft workflow.

Call widgets after `mdl:api/begin` and before `mdl:api/show` (or notice/confirmation conversion). Every API requires an explicit integer **width:1..1024** and a draft dialog. Pass trusted complete text components as **compounds**, e.g. `{text:"Balance",color:"gold"}`. Data is serialized as components, not interpolated into a quoted string. Resolve score/selector/storage-derived values server-side before rendering as with ordinary dialog text.

Each successful call appends one body entry and returns 1. Invalid width/bounds, a missing draft, unsupported checklist status, or missing required row fields return 0 without appending a partial widget. Inputs must otherwise obey the documented trusted component/list schemas; these APIs are not an arbitrary-NBT validation sandbox.

## 1. Stat card

```mcfunction
function mdl:api/widget/stat_card {title:{text:"Balance",color:"gold"},value:{text:"125 coins",bold:1b},description:{text:"Available to spend",color:"gray"},width:300}
```

Required fields: `title`, `value`, `description`, `width`. Renders title, value and description on separate lines. Use `{text:""}` to supply an intentionally empty component. There is no custom background, rounded border or actual economy read; the application supplies the value. Long content wraps according to vanilla font/layout behavior.

## 2. Key-value list

```mcfunction
function mdl:api/widget/key_value {title:{text:"Statistics",bold:1b},rows:[{label:{text:"Health"},value:{text:"20 / 20",color:"green"}},{label:{text:"Mana"},value:{text:"15",color:"aqua"}}],width:300}
```

Required fields: `title`, `rows`, `width`. Each row requires `label` and `value` components. **0..32 rows**; an empty list renders the title only. Rows retain source order and render as `label : value`, one per line. This is a flowing text list, not a fixed-column/aligned grid; long labels may wrap.

## 3. Checklist

```mcfunction
function mdl:api/widget/checklist {title:{text:"Objectives",bold:1b},items:[{label:{text:"Find the village"},status:"done"},{label:{text:"Speak to the librarian"},status:"pending"},{label:{text:"Timed bonus"},status:"failed"}],width:300}
```

Required fields: `title`, `items`, `width`. Each item requires a `label` component and one exact status:

| Status | Marker | Marker color |
|---|---|---|
| `done` | `[x]` | green |
| `pending` | `[ ]` | gray |
| `failed` | `[!]` | red |

**0..32 items**. Empty list renders the title only. Any invalid status rejects the whole widget rather than emitting earlier rows. Label styles remain developer-supplied; status colors apply to the markers. These are display-only status indicators. To accept player input use native boolean inputs and the existing validated input workflow, not this checklist.

## 4. Step indicator

```mcfunction
function mdl:api/widget/step_indicator {title:{text:"Checkout",bold:1b},steps:[{label:{text:"Cart"}},{label:{text:"Payment"}},{label:{text:"Receipt"}}],current:2,width:300}
```

Required fields: `title`, `steps`, `current`, `width`. Each step needs a `label` component. **1..16 steps**, and `current` is a **one-based integer** inside the actual list length. Earlier steps receive green `[+]`, the current step gets bold gold `[>]`, and later steps receive gray `[ ]`.

A current value of zero, a fractional value or `count+1` is invalid. This widget does not store wizard state, dispatch navigation or infer completion. Use a separate completed view if all steps have finished.

## Composition and updates

```mcfunction
function mdl:api/begin
function mdl:api/title {text:{text:"Dashboard"}}
function mdl:api/view {callback:[{type:"function",function:"example:dashboard"}],payload:{}}
# Append widgets here, using the API calls above.
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
function mdl:api/show
```

- Normal body order is preserved. Widgets do not alter buttons, tickets, inputs, columns, after_action or player state.
- `body_clear` removes them like other body messages; render them again to refresh their content.
- Normal `theme.body` merging is applied to the widget root through `api/body`. Explicit child component styling is retained; theme defaults can still affect inherited styles.
- Runtime templates store the rendered component snapshot, not a live data source. A renderer/refresh must recompute changed values.
- Scratch storage `mdl:widget` is synchronous/transient. Never use it as persistent application state or edit it during a widget call.

## Demo and tests

Install matching core and optional demo ZIPs, then run:

```mcfunction
function mdl_demo:demo/widgets
```

The optional home menu also links to **2.3 • Four composite widgets**. The demo uses illustrative static values and does not change inventory or balances.

The real-server RCON suite includes bounds, malformed rows/statuses, atomic rejection, component quoting, marker order and native codec acceptance. No graphical layout, clicking or full player callback/session test is claimed for these composite widgets. See TESTING.md for the exact test scope.
