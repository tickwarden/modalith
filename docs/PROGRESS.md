# Progress bars and live views

Progress bars are regular dialog text components assembled on the server. No plugin, resource pack, static dialog definition, or native progress-widget extension is needed.

## 1. A static progress bar

Call as a player:

```mcfunction
function mdl:api/begin
function mdl:api/title {text:{text:"Download status",color:"aqua"}}
function mdl:api/progress {label:{text:"Files"},value:65,max:100}
function mdl:api/exit {label:{text:"Close"},callback:"mdl:api/close",payload:{}}
function mdl:api/show
```

The bar is a snapshot with 20 default segments, 65%, and 65/100. Values below zero or above maximum are clamped; maximum must be 1–1,000,000. Percentages and filled segment counts round down.

## 2. Custom styling

Before appending the bar:

```mcfunction
function mdl:api/progress_style {segments:24,width:310,filled:{text:"|",color:"aqua",bold:true},empty:{text:"|",color:"dark_gray"}}
function mdl:api/progress {label:{text:"Upload",color:"white"},value:42,max:80}
```

Each glyph is a complete text component. Pick glyphs available in the default font or supply your own resource pack separately; the library does not promise exact pixel widths. Long labels and large segment counts can wrap. Style changes affect only bars appended afterward.

## 3. Display an application scoreboard value

Create your own objective once, in your application's load function:

```mcfunction
scoreboard objectives add download.progress dummy
```

In your own `example:render_status` function:

```mcfunction
function mdl:api/begin
function mdl:api/title {text:{text:"Live download",color:"aqua"}}
function mdl:api/view {callback:"example:render_status",payload:{}}

data modify storage example:ui progress set value {label:{text:"Files"},value:0,max:100}
execute store result storage example:ui progress.value int 1 run scoreboard players get @s download.progress
function mdl:api/progress with storage example:ui progress

function mdl:api/auto_refresh {ticks:20}
function mdl:api/exit {label:{text:"Close"},callback:"mdl:api/close",payload:{}}
function mdl:api/show
```

Initialize each player's `download.progress` to zero before opening this screen. Your application can update the score independently; the renderer only reads it. The example scratch storage is safe only within a complete synchronous per-player render chain.

## 4. Start and stop a live view

```mcfunction
execute as <player> at @s run function example:render_status
# Freeze the existing screen without closing:
execute as <player> run function mdl:api/auto_refresh_stop
```

The renderer must configure `view` and opt into `auto_refresh` on every render. Supported intervals are 5–1200 ticks; 20 ticks is a sensible demo default, not a real-time guarantee under server lag.

Automatic refresh preserves the original TTL. If TTL starts at 1200 ticks, refreshing every second does not keep the session alive indefinitely. A manual user-driven navigation/render is a new ordinary show and may reset TTL.

## Safety and interaction rules

- A renderer is display-only: do not give rewards, perform purchases, or push navigation history on every timed render.
- Automatic refresh replaces the dialog and issues fresh tickets; it is not an incremental animation. An old in-flight click is rejected safely.
- Dialogs with inputs are refused to avoid resetting unsubmitted user edits.
- Provide a routed exit; vanilla does not report every local dismissal, and a still-active timer can reopen a dismissed client screen until it stops/expires.
- Stop timers before switching to raw APIs, or use `api/close` to invalidate the managed session.
- `auto_refresh_stop` freezes the current timer, not the renderer definition. A later explicit render may enable it again.
- A callback that does not successfully show a replacement stops scheduling. It does not retry endlessly.
- Progress state is not a transaction, task queue, or downloaded-byte counter. Your application remains responsible for the actual task and its authoritative progress value.

## Built-in demo

Open `/trigger mdl.open`, then select **New in 1.2 • Live progress**. The bar follows a world-clock cycle and refreshes every 20 ticks. **Freeze this screen** rebuilds the frame once and disables its timer; **Back** uses renderer-based navigation.
