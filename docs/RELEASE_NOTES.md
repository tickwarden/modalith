# Modalith 1.3.0

Macro-native dialog library for **Minecraft Java 1.21.6**, data pack format **80**. No static dialog registry JSON, plugin, mod or resource pack required.

## Six new features

1. **Runtime theme registry:** reusable text styles and validated button/body/layout defaults; template snapshots preserve themes.
2. **Locale dictionaries:** explicit per-player language preference, component lookup with fallback, and localized builder helpers.
3. **Player UI state:** compound-valued set/get/remove/clear APIs with isolated persistence and explicit missing-key output.
4. **Notification FIFO:** up to 32 native modal notices, ticket-validated acknowledgement and previous-renderer restoration.
5. **Numeric form rules:** step/offset and allowed-value validation before callback acceptance, with a distinct rejection reason.
6. **Ranked catalogs:** stable ascending/descending sort of up to 64 items before normal pagination.

Progress bars, live refresh, templates, guards, cooldowns, lifecycle hooks and metrics remain available. The demo opener includes **New in 1.3 • Six extensions**.

## Install / upgrade

Replace the previous pack with `modalith-1.3.0-mc1.21.6.zip`, then run `/reload`. Do not install multiple versions together. The demo opener is public; replace it when integrating private/admin screens. Read `docs/EXTENSIONS.md` for signatures and examples.

## Validation

**120/120 local vanilla integration assertions passed**, including the previous 76 checks and 44 new extension checks. Seven release/layout unit tests and static consistency checks pass separately. No graphical client UI QA, production-scale certification or GitHub-hosted Actions run is claimed.

## Honest boundaries

Locale selection is explicit, not automatic Minecraft-language detection. Notifications are modal notices, not native toasts or guaranteed delivery; enqueueing does not interrupt the UI until display is requested. Themes and all registry/path keys are trusted developer data. State is not a transaction database. Numeric rules do not replace business checks or enable arbitrary text transport. Sorting is a bounded synchronous operation, not an unbounded query engine.

Notification-specific frames cannot be reused as templates. Existing ordinary dialog templates remain supported. Privileged callbacks must still recheck permission, stock, balance and authoritative application state.
