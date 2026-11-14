# 2.2 UI controls and Minecraft 26.3

Modalith 2.2 targets **Minecraft Java 26.3**, **Java 25**, and data pack version **121.0**. This is not a metadata-only compatibility claim: the official 26.3 server loads the core/demo/fixture packs, and server-side draft/codec checks are recorded separately. Full player/protocol integration remains unverified on this target; see TESTING.md.

## Example

```mcfunction
function mdl:api/begin
function mdl:api/title {text:{text:"New controls",color:"gold"}}
function mdl:api/body {text:{text:"Placeholder"},width:300}
function mdl:api/body_clear
function mdl:api/body {text:{text:"A fresh body."},width:300}
function mdl:api/columns {columns:3}
function mdl:api/after_action {value:"none"}
function mdl:action/copy_to_clipboard {label:{text:"Placeholder"},value:"Modalith"}
function mdl:api/button_label {label:{text:"Copy project name",color:"aqua"}}
function mdl:api/button_tooltip {text:{text:"Copies the name to your clipboard.",color:"gray"}}
function mdl:api/button_width {width:200}
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
function mdl:api/show
```

Install the optional demo pack and run `function mdl_demo:demo/ui_controls` for a runnable showcase.

## Two new features

### `mdl:api/button_label {label:<component>}`

Replaces the **last draft action button's** label. Accepts a complete component, including style, lists and quoted text. Does not append another button, alter its callback or reissue tickets. Explicit replacement overrides any label style previously supplied by a theme. Returns 1 on success; 0 when no action button exists.

### `mdl:api/body_clear`

Sets the current draft's body to an empty list. Rebuild it with `body`, `item`, `progress` or localized/themed body helpers. It does not clear title, inputs, routes or player state. Returns 0 if no draft dialog exists, otherwise 1.

## Tooltip

### `mdl:api/button_tooltip {text:<component>}`

Replaces the last action button's tooltip with a full text component. This works for routed and native action buttons. To supply arbitrary quotes, pass a complete compound component; it is substituted as serialized SNBT rather than interpolated inside a string. An empty text component can visually clear a previous tooltip. Returns 0 if no action button exists, otherwise 1.

Label and tooltip setters, like button_width, must be called after appending their target and **before** `show`, `notice` or `confirmation` conversion. They do not target an exit button or edit a dialog already committed to a player. If a first/second action is later converted into notice/confirmation buttons, its label/tooltip moves with it.

## Columns

### `mdl:api/columns {columns:<int>}`

Sets the current **multi_action draft** column count. The library accepts integer values **1..8**, consistent with its bounded theme layout policy. Invalid/fractional values and non-multi_action dialogs return 0 without modifying the draft. Returns 1 on success. The existing `options {columns,escape}` API delegates to the same validation and validates escape before applying changes.

Vanilla may allow a wider positive range; this API intentionally has the documented 1..8 library bound. Explicit setters override theme defaults already applied to the draft.

## after_action

### `mdl:api/after_action {value:"close"|"none"|"wait_for_response"}`

- **close**: use vanilla's close-after-action behavior.
- **none**: keep the client dialog open after the action; the setter forces `pause:0b` to satisfy the native codec requirement.
- **wait_for_response**: use vanilla's response-wait behavior. This remains the default established by `begin`.

Unknown values or a missing draft return 0 without changing it; valid values return 1. Switching away from `none` does not restore a former pause setting. This setter does not otherwise change pause policy or session TTL.

**Important:** after_action controls native client behavior. A routed server callback still consumes its ticket/session and explicitly clears the old UI before dispatch. `none` does not make a one-use server route reusable or bypass refresh/close logic. Native copy/suggest/URL buttons have no server acknowledgement and keep their vanilla behavior.

## Migration notes

- Install core/demo ZIPs named `*-mc26.3.zip`, not the old 1.21.6 builds. Back up your world before upgrading Minecraft; the world-version upgrade is not reversible safely.
- Metadata now uses `min_format:[121,0]` and `max_format:[121,0]`; legacy pack_format 80 is removed from the shipped packs and test fixtures.
- Demo predicate discriminator is `type`, not the legacy `condition` field. Apply the equivalent migration to your own predicates; changing pack metadata alone is not enough.
- Earlier callback arrays remain the intended API. Review server-specific behavior in your deployment; Paper/Fabric/proxy compatibility is not asserted.

## Authoritative target provenance

The official version manifest identifies 26.3 as a release and requires Java 25:
https://piston-meta.mojang.com/v1/packages/9f67e10ed013deeaad20ac3c800652765d493408/26.3.json

The official server archive's nested `version.json` declares protocol 777 and data pack version 121.0. The test report records the actual server hash and runtime. No third-party pack-format table is used as the source of truth.
