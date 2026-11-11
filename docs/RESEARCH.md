# Research: Minecraft 1.21.6 dialogs and macros

## Inline dialog definitions are supported

Mojang's Java Edition 1.21.6 release notes explicitly allow both registry references and inline dialog values. The target data pack format is 80. Therefore a valid function macro such as `$dialog show @s $(dialog)` is not inherently a `Failed to load function` error: the server serializes the compound and parses the expanded command when invoked.

Missing macro parameters or invalid codec fields can still fail. Modalith uses `$return run dialog show` so show success propagates explicitly before committing player state.

Sources:

- [Mojang: Java Edition 1.21.6](https://www.minecraft.net/en-us/article/minecraft-java-edition-1-21-6)
- [Minecraft Wiki: /dialog](https://minecraft.wiki/w/Commands/dialog)
- [Minecraft Wiki: dialog definition, inputs, and actions](https://minecraft.wiki/w/Dialog)

## ToolkitMC reference investigation

The initial implementation investigated `ToolkitMC/glc_permissions` at commit `05132416be7ca3622ef5191077b3430b0c834c39`:

- [`glc_menu/.../show_final.mcfunction`](https://github.com/ToolkitMC/glc_permissions/blob/05132416be7ca3622ef5191077b3430b0c834c39/packs/DP/data/glc_menu/function/handler/dialog/show_final.mcfunction) uses `$execute as $(NAME) at @s run dialog show @s $(ui)`.
- [`custom_admin/.../dialog_run.mcfunction`](https://github.com/ToolkitMC/glc_permissions/blob/05132416be7ca3622ef5191077b3430b0c834c39/packs/DP/data/custom_admin/function/handler/execute/types/dialog_run.mcfunction) uses `$execute as $(selector) at @s run dialog show @s $(dialog)`.
- [`custom_admin/.../confirm/request.mcfunction`](https://github.com/ToolkitMC/glc_permissions/blob/05132416be7ca3622ef5191077b3430b0c834c39/packs/DP/data/custom_admin/function/handler/confirm/request.mcfunction) combines inline confirmation UI and trigger buttons.

Modalith independently implements a builder/session/router architecture around the same vanilla technique. This observation is not a claim about the organization's activity or the project's general quality.

## Two macro layers

1. **Server function macro:** serializes trusted storage compounds into commands.
2. **Client dialog macro:** `minecraft:dynamic/run_command` expands input keys and executes as the player, with the player's command permissions.

Modalith stores client templates as data before server expansion. The inserted `$(value)` or `$(power)$(enabled)$(mode)` text is not recursively expanded on the server. Tests confirm the literal client macro survives in decoded dialog packets.

## Practical limits the design works around

| Assumption | Working technique |
|---|---|
| Each screen needs a static dialog registry file. | Runtime storage compound → inline macro. |
| Non-OP players cannot reach server callbacks. | A numeric `/trigger` is validated and dispatched from the server tick function. |
| A large catalog requires a file for every page. | Runtime list models and a generic pagination renderer. |
| Back navigation needs an old dialog registry ID. | Save renderer/payload snapshots and re-render with fresh tickets. |
| One trigger cannot atomically carry several controls. | Fixed-width decimal fields packed with a gate, within signed integer limits. |
| A reusable dialog must reuse its old callbacks/tickets. | Store a trusted template and rekey routed commands for each owner on instantiation. |
| Render-time visibility is sufficient authorization. | Evaluate server predicates immediately before dispatch; keep business checks in callbacks. |

## Limits this library does not remove

- Vanilla does not expose `minecraft:custom` / `minecraft:dynamic/custom` client packets as datapack callback events. These are intended for modded/plugin servers.
- `run_command` does not grant the player operator permission. Putting `/function` or `/data` in a client template does not change that.
- Showing a text box is not the same as collecting arbitrary text from a non-OP player into server storage. The text demo is UI-only. Numeric packing is not an unlimited text transport.
- Macro substitution does not remove codec bounds, packet sizes, NBT depth, command-chain limits, layout constraints, or the UI warning indicator. For example, action button width remains codec-limited.
- A new native dialog replaces the previous dialog. History is emulated server-side, not a native client stack.
- A waiting screen is not a secure permanent player lock. Client exit/back behavior remains available.
- Quick Actions/pause-menu tags reference registry dialogs. To preserve zero static dialog definitions, this project uses `/trigger mdl.open`, not a registry-backed G-key bootstrap.
- Cooldown and metrics do not provide packet-level anti-spam protection, authentication, or crash-safe database transactions.

The target runtime, rather than a future wiki revision, is authoritative for compatibility claims. Testing uses vanilla 1.21.6. No graphical Minecraft client screenshots or pixel-level UI validation are claimed.
