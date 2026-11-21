# Nine UI features - 2.5.0

Minecraft Java 26.3, datapack 121.0. These are synchronous draft APIs: call between
`mdl:api/begin` and `mdl:api/show` as the same player. Existing ownership rules and
trusted developer macro schemas apply. No static dialog definitions are added.
Success returns 1; instrumented rejection returns 0 and records a fixed diagnostic.
Known validation failures leave the dialog unchanged (scratch storage may change).
Missing macro arguments or malformed command interpolation can fail in the engine
before library validation: this is not an arbitrary-NBT sandbox.

## Three read-only widgets

Every widget appends one ordinary `minecraft:plain_message` body. Supply compound
text components and an integer-valued numeric `width` in 1..1024. Complete components
preserve quotes, backslashes, newlines and styles; literal `$()` text is not evaluated
as a second macro. There are no custom backgrounds, native tables or interactive rows.
Existing theme.body root merging applies, just as for the older widgets.

### 1. Callout

```mcfunction
function mdl:api/widget/callout {title:{text:"Backup needed",bold:1b},description:{text:"Save your world before upgrading."},level:"warning",width:300}
```

Required: title, description, level, width. Exact levels: `info` (aqua), `success`
(green), `warning` (gold), `error` (red). A fixed colored marker precedes the title;
the description starts on the next line. Explicit component styles remain supplied
by the application. Unsupported levels or non-compound components reject atomically.
This call does not itself log a diagnostic warning: level is display content only.

### 2. Comparison

```mcfunction
function mdl:api/widget/comparison {title:{text:"Equipment"},left:{text:"Current"},right:{text:"Candidate"},rows:[{label:{text:"Defense"},left:{text:"8"},right:{text:"12"}}],width:300}
```

Required: title, left/right heading components, rows, width. Rows are a compound list
of 0..32 entries, each with label, left and right components. Renders headings as
`Current / Candidate` and each row as `Defense : 8 / 12`, in source order. This is
flowing text, not aligned columns, automatic scoring or an equipment mutation.
An empty list renders the title/headings. Any malformed row rejects the whole widget.

### 3. Timeline

```mcfunction
function mdl:api/widget/timeline {title:{text:"Quest history"},events:[{time:{text:"Day 1"},title:{text:"Arrival"},description:{text:"Reached the village."}}],width:300}
```

Required: title, events, width. Events are a compound list of 0..32 entries, each with
time, title and description components. Renders `[time] title` followed by an indented
description. Source order is retained; no sorting, date parsing, clock, scheduler or
persistent event log is created. Empty lists render only the title.

## Three draft settings

### 4. Escape behavior

```mcfunction
function mdl:api/escape {enabled:1}
```

Sets `can_close_with_escape` independently of columns. Accepts numeric 0/1, including
NBT byte booleans, and normalizes to byte. Other values fail without changing the draft.
Vanilla dialog-type behavior still applies: in a confirmation, Escape invokes the no
action when closing is permitted. This setting is not authorization or a security lock.
The old `options {columns,escape}` API remains available.

### 5. Pause behavior

```mcfunction
function mdl:api/pause {enabled:0}
```

Same numeric 0/1 contract. Sets the native `pause` flag, not a scheduler or server freeze.
Pausing is meaningful in an eligible single-player game; multiplayer simulation does
not stop for a player's dialog. Setting pause true while `after_action:"none"` fails.
The existing `after_action {value:"none"}` setter still normalizes pause to false.
`begin` defaults to pause false; nothing is changed in an already-shown dialog.

### 6. Default body width

```mcfunction
function mdl:api/body_width {width:240}
function mdl:api/body_default {text:{text:"Uses 240"}}
function mdl:api/body {text:{text:"Explicit override"},width:180}
```

Width is integer-valued numeric 1..1024. The default is draft-local, resets to 300 on
`begin`, and is included in template snapshots/restoration. It is not a global setting
and does not retroactively resize existing entries, widgets, inputs or buttons.

Minecraft macros cannot have optional arguments. Therefore existing `body {text,width}`
keeps its explicit-width signature; the supporting `body_default {text}` entrypoint uses
the configured default (300 if absent in an older draft). Explicit body width wins and
does not change the default. Existing valid explicit-width calls remain compatible;
body now rejects known invalid widths/components before appending. This supporting
entrypoint is part of the default-width feature, not a tenth advertised feature.

## Three draft tools

### 7. Structural validator

```mcfunction
execute store result score #valid example.tmp run function mdl:api/validate
```

Read-only with respect to the draft. Returns 1 for the supported structural subset or
0 with the first detected diagnostic. Does not show, commit, repair, allocate tickets
or verify the owner/player. Supports library multi_action, notice and confirmation.
Checks title compound, supported type, existing first multi-action button (show's
fallback is not inserted), yes/no presence for confirmation, columns 1..8 if supplied,
known after_action, boolean flags, pause/none conflict, and body list (up to 1024 entries).
Each body must be plain_message with compound contents, or item with an item compound;
explicit body widths must be integer-valued 1..1024. Omitted optional native fields are
left to vanilla defaults. No automatic validation is inserted into `show`.

This is deliberately NOT the complete native codec. It does not deeply validate input
schemas, every action/label, text component semantics, item IDs, routes/permissions,
macro instantiation or owner identity. A passing result does not guarantee `show` will
succeed. The Minecraft codec remains authoritative. The 1024-body bound is a library
preflight policy, not a claimed vanilla limit. Use before show after adding actions.

### 8. Indexed body replacement

```mcfunction
function mdl:api/body_set {index:0,text:{text:"Updated",color:"gold"},width:300}
```

Zero-based nonnegative integer-valued index. Only an existing plain_message can be
replaced; item entries reject. Replaces the entire selected entry with the supplied
text/width and normal root body theme merge. Body order/length, other entries, inputs,
actions, routes and tickets are unchanged. Width is explicit; it does not inherit the
new default. Out-of-range indices, fractional values, invalid components and widths
reject before mutation. This edits a draft; use the existing refresh renderer to
update an already-open dialog.

### 9. Indexed body removal

```mcfunction
function mdl:api/body_remove {index:1}
```

Removes one existing body entry (text or item). Later entries shift left; negative
indices, fractions, absent entries and empty lists fail. Routes/actions are untouched.
To clear all body entries use the existing `body_clear` API.

## Numeric macro caveat

Pass trusted numeric NBT values, not numeric strings. Integral numeric NBT types may
compare equal in Minecraft; 1.0 and 1 are accepted as integer-valued. Fractional values
are rejected. Numeric strings can lose their original type during macro substitution,
so these APIs do not promise preservation or detection of the caller's original NBT type.

## Demo and verification

Install the matching optional demo pack, then call `mdl_demo:demo/nine_features` as a
player or use its home menu. The demo is absent from the core archive. The automated
suite exercises APIs and actual native codecs with RCON, not player sessions or GUI
rendering. See [testing](TESTING.md) for current evidence and network-isolation policy.
