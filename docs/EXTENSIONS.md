# Six extensions — introduced in 1.3, examples updated for 2.0

All examples execute as a player after library initialization. Finish builder chains synchronously. Keys/locales are **trusted developer-controlled simple identifiers**, conventionally `[a-z0-9_]+`; never substitute untrusted player text into them. Component and state parameters are compounds, not bare strings.

## 1. Runtime themes

```mcfunction
function mdl:api/theme_register {key:"ocean",theme:{title:{color:"aqua",bold:true},body:{color:"gray"},button:{color:"aqua"},button_width:170,body_width:310,columns:2}}
function mdl:api/begin
function mdl:api/theme_apply {key:"ocean"}
function mdl:api/title {text:{text:"Themed menu"}}
function mdl:api/themed_body {text:{text:"The theme supplies body width and text style."}}
function mdl:api/button {label:{text:"Continue"},callback:[{type:"function",function:"example:continue"}],payload:{}}
function mdl:api/show
```

`theme_register` creates or replaces `mdl:themes entries.<key>`. Omitted fields default to empty title/body/button style compounds, button width 150, body width 300, and two columns. Widths must be 1–1024; columns 1–8. Invalid numeric defaults return 0 without replacing a registered theme. `theme_apply` returns 0 if the theme is missing, otherwise copies it to the current draft.

Apply immediately after begin. The theme styles the current title and future title/body/routed-button additions; it does not walk existing bodies/buttons and restyle them retroactively. Style compounds merge **after** supplied text components, so a theme color can override an explicit element color. Keep theme styles presentation-only (`color`, `bold`, `italic`, etc.); they are trusted component data, not a CSS parser or a whitelist that rejects every non-style field.

`themed_body {text:<component>}` uses the theme's body width; ordinary `body {text,width}` keeps its explicit width while applying the body style. Routed buttons, including guarded/localized buttons, get theme button width/style. Exit actions, raw buttons, inputs, item bodies and progress glyphs are not globally restyled. Use their dedicated APIs.

Templates preserve the theme snapshot. Later registry updates do not modify existing frames/templates. Theme registries survive reload; there is no automatic eviction or remote resource loading.

## 2. Locale dictionaries and fallback

```mcfunction
function mdl:api/translation_register {locale:"en_us",key:"welcome",text:{text:"Welcome",color:"green"}}
function mdl:api/translation_register {locale:"en_gb",key:"welcome",text:{text:"Welcome back",color:"aqua"}}
function mdl:api/locale_set {locale:"en_gb"}
function mdl:api/begin
function mdl:api/localized_title {key:"welcome"}
function mdl:api/localized_body {key:"welcome",width:300}
function mdl:api/localized_button {key:"welcome",callback:[{type:"function",function:"example:continue"}],payload:{screen:2}}
function mdl:api/show
```

- `translation_register {locale,key,text}` stores a complete text component in `mdl:translations entries.<locale>.<key>`.
- `locale_set {locale}` sets the current player's explicit locale preference.
- `translate {key}` resolves a component into shared scratch `storage mdl:i18n result`.
- Localized title/body/button helpers resolve and forward the component to the corresponding normal builder API. Body still requires width; button still requires a trusted callback and compound payload.

Resolution order: current player's entry → configured fallback entry → red `[missing: key]` component. The default fallback is `en_us`:

```mcfunction
data modify storage mdl:config fallback_locale set value "en_us"
```

This does **not** detect the client's Minecraft language, perform machine translation, load external language files, or interpolate arbitrary variables into strings. Register the desired components yourself. You may register ordinary rich components; vanilla dialog component-resolution limits still apply. Locale selection and dictionaries survive reload. Components are read at render time, not automatically pushed when a dictionary changes.

The supplied demo and documentation stay in English. Applications may register other languages through the same API.

## 3. Player-scoped UI state

```mcfunction
function mdl:api/state_set {key:"selection",value:{tab:2,quest:7,confirmed:0b}}
function mdl:api/state_get {key:"selection"}
# Inspect storage mdl:state result and found synchronously.
function mdl:api/state_remove {key:"selection"}
function mdl:api/state_clear
```

Values are **compound records**. Wrap scalars, e.g. `{value:17}` or `{text:"note"}`. This avoids unsafe bare-string macro interpolation and gives your application a stable schema.

Persistent location: `mdl:db players.p<ID>.state.<key>`. Get clears shared `mdl:state result` to `{}` and `found` to `0b`, then copies the record and sets `found:1b` if it exists. An existing empty compound is distinguishable from a missing key. `state_get` returns 1 for found and 0 for missing.

State is isolated per player, survives close/reload, and does not depend on `mdl:event` lifetime. Remove deletes one key; clear replaces only the state compound and does not erase locale, history, metrics or notification queues. `api/forget` resets the entire player library record, including these new fields. There is no storage quota, schema migration, encryption, automatic garbage collection or transaction database.

Outputs remain shared scratch: copy them to your own storage before starting another player lookup, builder, hook or delayed operation. Never treat client-proposed values as authoritative inventory/economy state.

## 4. FIFO notification queue

```mcfunction
function mdl:api/notify {title:{text:"Quest updated"},body:{text:"The forest route is unlocked."},width:300}
function mdl:api/notify {title:{text:"Second message"},body:{text:"Shown after acknowledgement."},width:300}
# Enqueueing does not interrupt the current UI. Explicitly start display:
function mdl:api/notifications_show
```

This is a queue of **native modal notice dialogs**, not a toast overlay or chat notification. Each player has at most 32 queued entries. Width must be 1–1024. Invalid width or a full queue causes `notify` to return 0. Accepted entries are server-owned title/body compounds; no client text is turned into commands.

`notifications_show` returns 0 for an empty queue. When starting a queue display, it saves the current renderer once, then shows the first entry. A routed **Continue** button invokes `notification_next`; native notice Escape uses its acknowledgement action too. Ordinary session tickets, cooldowns and validation protect acknowledgement. The entry is removed only on acknowledgement; the next entry is shown in FIFO order. Draining the queue restores the saved renderer, or simply closes if there was no renderer.

```mcfunction
# Drop all pending notifications:
function mdl:api/notifications_clear
```

Clearing a currently visible notification restores the previous renderer; clearing a background queue leaves an unrelated active screen alone. Each notification has a fresh managed session, ordinary TTL and no auto-refresh. Timeout/reload/close do not silently acknowledge or dequeue messages; explicitly show again to resume pending entries, or clear them.

The queue does not automatically interrupt gameplay, run while offline, guarantee delivery, or provide an arbitrary-depth modal stack. Do not navigate away through unrelated custom server calls while a queue workflow is open; finish or clear it first. Return renderers must follow normal pure-builder rules; unsubmitted input values in the previous screen are not serialized/restored.

Notification frames contain queue-specific acknowledgement routes and **cannot be saved/loaded as reusable templates**. Ordinary notices created by `api/notice` remain reusable. Queue fields are player-scoped and persist until acknowledgement, clear, or `forget`.

## 5. Numeric form validation rules

After creating a numeric receiver, before show:

```mcfunction
function mdl:api/form_digit {label:{text:"Save"},callback:[{type:"function",function:"example:save"}],payload:{},min:0,max:9}
function mdl:api/form_rules {step:2,offset:0,allowed:[{value:2},{value:4},{value:8}]}
```

A decoded value must satisfy all of:

1. Existing active form gate and min/max checks.
2. `(value - offset) % step == 0`.
3. Membership in `allowed`, if the list is nonempty.
4. Existing cooldown and predicate authorization.

Step must be 1–1,000,000; offset 0–999,999; allowed contains at most 64 compounds of the form `{value:<integer>}`. Empty `allowed:[]` disables the allowlist, **not** the step rule. Offset establishes a congruence class; it is not an additional minimum. Use the receiver's min/max for bounds. Invalid API parameters or an absent form receiver return 0 without replacing previous rules.

Failure emits `#mdl:on_reject` with `reason:"validation"`, increments rejection metrics, restores the active screen and rearms input without consuming the session. Success continues through the existing acceptance path. Rules are included in template snapshots and survive fresh-ticket cloning.

For packed multi-field forms, rules apply to the **combined numeric code**. They do not automatically validate every decoded field or business constraint. Callback-level checks remain necessary. This does not add arbitrary non-OP text transport.

## 6. Stable ranked catalogs

```mcfunction
function mdl:api/catalog_sorted {title:{text:"Priorities"},size:8,page:0,descending:1b,items:[{label:{text:"Normal"},rank:10,callback:[{type:"function",function:"example:choose"}],payload:{id:1}},{label:{text:"Urgent first"},rank:50,callback:[{type:"function",function:"example:choose"}],payload:{id:2}},{label:{text:"Urgent second"},rank:50,callback:[{type:"function",function:"example:choose"}],payload:{id:3}}]}
```

The API accepts up to **64 items**, each using the normal button record plus an optional signed integer `rank`. Missing rank is zero. `descending:0b` sorts low-to-high; `1b` sorts high-to-low. Equal ranks preserve original order. The sorted records, including their trusted payloads, become the catalog model before the existing page renderer runs. Page size remains 1–27; page numbers follow ordinary clamping behavior.

More than 64 items or an invalid descending flag returns 0 before rendering. Use storage for larger command arguments rather than exceeding chat/RCON command lengths:

```mcfunction
# Build example:ui ranked with title, size, page, descending, items...
function mdl:api/catalog_sorted with storage example:ui ranked
```

Sorting is synchronous and quadratic, deliberately bounded. The maximum 64-record reverse-order case is covered by integration tests under default command limits. It is not an unbounded search/index service. Do not repeatedly sort large catalogs in a five-tick live renderer. Normal unsorted catalogs retain their existing behavior and do not acquire the 64-item sort limit.

Changing source ranks later does not mutate an already committed catalog; call the sorted API again with the new model. Sorting does not implement per-item predicate filtering, automatic authorization, or stock checking. Use guard-aware callbacks/business checks where needed.

## Demo entry point

`/trigger mdl.open` → **New in 1.3 • Six extensions**. The hub uses a runtime theme and localized title, and provides player-state, two-notification, validated-form and ranked-catalog examples.
