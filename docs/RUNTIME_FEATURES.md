# Six runtime features — 2.1

All inputs below are **trusted server developer data**. No feature adds arbitrary client command transport or a security sandbox. Demo: `function mdl_demo:demo/runtime`, also linked from the home menu.

## 1. Stop a chain on failure

```mcfunction
function mdl:api/actions {callback:[{type:"function",function:"shop:check_and_purchase",payload:{sku:12},stop_on_failure:1b},{type:"refresh"}],payload:{}}
```

`stop_on_failure:1b` is an optional **per-action** policy. A result of exactly zero (including cancellation or an unsupported type) stops remaining entries in that chain **after** its after_action hook. The dispatcher returns zero for a stopped chain. With no flag, existing continue-on-failure behavior is unchanged. Nonzero results, including negative results, do not trigger this policy. Business functions should explicitly return 0 on failure and 1 on success. A nested conditional propagates its selected chain's result. Nothing is rolled back; this is not a transaction.

The existing 64-entry execution and 16-active-chain bounds remain. Reaching the entry cap also returns zero. Earlier side effects are not undone.

## 2. Delayed server actions

```mcfunction
function mdl:api/action_delay {ticks:20,callback:[{type:"run_command",cmd:"playsound minecraft:entity.experience_orb.pickup player @s ~ ~ ~ 0.5 1"}],payload:{}}
# Or inside a routed chain (inherits effective payload):
function mdl:api/actions {callback:[{type:"delay",ticks:20,callback:[{type:"function",function:"example:later"}]}],payload:{sku:12}}
function mdl:api/action_delay_cancel
```

One pending job per player. Scheduling returns 1, or 0 if a job already exists or `ticks` is not an integer in **1..1200**. The current chain continues immediately; delay is scheduling, **not a pause of the current chain**. Only the nested callback array is deferred.

The job snapshots callback/payload and executes once as that player at their **current** position. It is removed before execution, so it may schedule another job. The countdown advances only while the player is online. Closing a dialog does not cancel it. Explicit cancellation clears it; reload changes the library epoch, causing stale jobs to be discarded on the next online tick. There is no promise of reliable offline delivery, wall-clock deadlines, or server restart recovery. Deferred callbacks must recheck current authorization and business state. Delay registration and the later dispatched actions emit ordinary action hooks when used through the dispatcher.

## 3. Predicate-controlled branches

```mcfunction
function mdl:api/actions {callback:[{type:"conditional",predicate:"example:can_use",yes:[{type:"function",function:"example:allowed"}],no:[{type:"refresh"}]}],payload:{}}
# Direct API, all four fields required:
function mdl:api/action_conditional {predicate:"example:can_use",yes:[],no:[],payload:{}}
```

Tests the server predicate as the current player at execution time. Exactly one array executes, sharing the effective payload. Missing/invalid predicates never select `yes`; they select `no`, though vanilla may log the missing predicate error. Both arrays are required; use `[]` for a no-op branch. Nested arrays count toward normal depth bounds. This is not a replacement for permission checks inside sensitive functions.

## 4. Enable/disable the last draft button

```mcfunction
function mdl:api/button {label:{text:"Unavailable"},callback:[{type:"function",function:"example:restricted"}],payload:{}}
function mdl:api/button_enabled {enabled:0b}
# Re-enable the same last button, before appending another:
function mdl:api/button_enabled {enabled:1b}
```

Operates only on the most recently appended action button, before show/notice/confirmation conversion. Accepts 0/1 or 0b/1b. Invalid values or a missing target return zero.

Disabling removes its native action and marks its associated privileged route/form as disabled. Forged numeric submissions are rejected with reason **`disabled`** and preserve the session. Enabling restores the saved action and allows the route again. Native action buttons can be toggled too, but have no privileged route to gate.

Only one last-button restoration snapshot is kept per draft; re-enable that button before appending/disabling another if you need restoration. Repeated disable is idempotent. `begin` clears the snapshot. Templates preserve the last disabled snapshot and rekey its hidden command/template, so re-enabled templates use fresh tickets. Toggle before conversion; this API does not target exit/yes/no buttons or mutate already displayed player frames. Business checks remain necessary even for enabled buttons.

## 5. Exact-token catalog search/filter

```mcfunction
function mdl:api/catalog_filter {title:{text:"Rare gear"},size:8,page:0,query:"rare",items:[{label:{text:"Rare sword"},tags:["rare","gear"],callback:[{type:"function",function:"example:choose"}],payload:{id:1}},{label:{text:"Common sword"},tags:["common","gear"],callback:[{type:"function",function:"example:choose"}],payload:{id:2}}]}
```

A bounded filter over at most **64** supplied records, followed by the ordinary catalog renderer. `size` is 1..27; page is clamped by existing pagination. Input order, callbacks and payloads are preserved. `query:""` includes all records. A nonempty query matches an exact, case-sensitive member of `tags`. No substring, free-text input, regex, fuzzy search or automatic client search box is claimed. The query and tags are server-owned tokens; use simple trusted identifiers. Ordinary catalog pagination/history operate on the resulting filtered snapshot; reopening does not re-query external data.

## 6. Player favorites

```mcfunction
function mdl:api/favorite_set {key:"rare_sword",item:{label:{text:"Rare sword"},tags:["rare"],callback:[{type:"function",function:"example:choose"}],payload:{id:1}}}
function mdl:api/favorite_get {key:"rare_sword"}
function mdl:api/catalog_favorites {title:{text:"My favorites"},size:8,page:0}
function mdl:api/favorite_remove {key:"rare_sword"}
function mdl:api/favorites_clear
```

Each player owns up to **64** `{key,item}` records. Keys are trusted simple identifiers. Item compounds must be valid ordinary catalog records. New entries return zero at capacity; updating an existing key is allowed. Updating moves that record to the end. Favorites retain trusted item snapshots, including callbacks/payloads; they are not references that automatically track later source catalog edits. Validate a favorite's business payload when it is selected.

`favorite_get` resets `mdl:favorites result` to `{}` and `found` to `0b`; on success copies the item, sets `found:1b` and returns 1. Missing entries return zero without leaking stale output. Remove returns the NBT removal result. Favorites are player-isolated and survive reload; clearing UI state does not clear them. The favorites catalog renders the saved order through existing pagination and issues fresh route tickets. The storage is a convenience list, not transactional inventory or an account-level cross-server database.
