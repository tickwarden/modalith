# Changelog

## 2.1.0

### Six new features

1. Per-action stop_on_failure policy in ordered server chains.
2. One cancellable delayed callback per player, 1–1200 online ticks, reload epoch invalidation.
3. Predicate-controlled yes/no typed callback branches.
4. Last-button enable/disable with native action removal and server route rejection.
5. Stable bounded catalog filtering using exact server-owned tag tokens.
6. Persistent player favorites with up to 64 items and a favorites catalog.

### Also included

- Updated the 2.0 demo home, native/typed action showcase and optional hook companion examples.
- Added validated button_width and exit_width setters for per-button width overrides without changing existing builder signatures.

## 2.0.0

- Breaking: callback fields are typed action arrays, including views, forms and catalogs.
- Added eight action entry points: run_command, open_url, suggest_command, copy_to_clipboard, show_dialog, function, close and refresh.
- Server action chains preserve order and snapshot pending actions across nested dispatch. Bounded to 64 actions per chain and 16 nested chains.
- Added before_action/after_action hooks with cancellation, action index and command result metadata.
- Moved demo functions, codec examples and demo predicates into mdl_demo. Existing mdl:demo/* references must migrate.
- Native client actions remain single client actions; arbitrary client action batching is not claimed.


## 1.3.0

### Added — six feature groups

1. Runtime theme registry with title/body/button styles and validated layout defaults.
2. Per-player locales, server-side translation dictionaries, fallback lookup and localized title/body/button helpers.
3. Player-scoped compound UI state with set/get/remove/clear and explicit missing-state output.
4. Bounded FIFO notification queue, validated acknowledgement, native notices and previous-renderer restoration.
5. Numeric form step/offset and allowed-value validation with a distinct `validation` rejection reason.
6. Stable ascending/descending catalog rank sorting, bounded to 64 records before pagination.

### Changed

- Templates retain theme snapshots and numeric rules. Notification frames cannot be saved or loaded as reusable templates.
- Added an English six-feature demo hub, full extension reference and new vanilla integration checks.
- Versioned build/release instructions target 1.3.0. Existing APIs and the zero-static-dialog design remain intact.

### Limits

Theme/translation/state keys and component content are trusted developer data. Locale selection is explicit, not automatic client-language detection. Notifications are modal notices, not native toasts; enqueue does not interrupt the current UI until explicitly shown. Ranked sorting is a bounded synchronous operation, not an unbounded query engine.

## 1.2.0

### Added — two features

1. Text-component progress bars: labels, current/max values, integer percentages, custom filled/empty components, 1–64 segments, and safe value clamping.
2. Per-player automatic live-view refresh: opt-in render intervals, fresh tickets, unchanged original TTL, stop-on-close/reload, explicit freeze, and form/input safeguards.

### Changed

- Templates preserve progress styling and refresh settings; templates from 1.1 without these fields use defaults.
- Added a live world-clock progress demo and an English integration tutorial.
- Extended local vanilla coverage from 50 to 76 assertions, covering progress boundaries, styling, cloning, timer isolation, TTL, stop, input rejection, and non-rendering callbacks.
- Versioned release packaging and publishing instructions now target 1.2.0.

### Notes

Progress bars are ordinary text bodies, not a native widget or bossbar. Live views replace the dialog and reissue tickets; automatic refresh refuses dialogs containing inputs. Renderers must be pure, repeatable display builders. Refresh counts as a managed show and emits its normal observer.

## 1.1.0

### Added — five feature groups

1. Runtime template registry: save/load/delete trusted drafts; reissue owner-bound route tickets and numeric form gates on instantiation.
2. Predicate-guarded buttons and numeric forms: evaluate current server state immediately before dispatch; missing predicates fail closed.
3. Per-player callback cooldowns with a configurable default, a setter API, and session-preserving retry behavior.
4. Lifecycle observer tags for managed show, explicit close, timeout, and rejection, with typed event metadata.
5. Global and per-player usage counters, storage snapshots, and player metric reset.

### Changed

- Translated all runtime UI and project documentation to English.
- Added GitHub-ready CI/release workflows, deterministic packaging, checksums, contribution/security policies, issue templates, and publishing instructions for `tickwarden/modalith`.
- Extended local vanilla integration coverage from 28 to 50 assertions and added release/layout unit tests.
- Lifecycle events now clear stale accepted-event fields. Click events do not expose a leftover numeric form value.
- Close is observer-idempotent; timeout sends timeout then explicit-close notifications. Consumed callback transitions are not close notifications.
- Raw APIs and the public demo opener remain outside callback throttling and managed metrics/hooks.

### Compatibility

Existing 1.0 builder, catalog, navigation, and numeric form API signatures remain available. New cooldown defaults to four ticks; set `mdl:config cooldown` to zero to opt out. No compatibility claim beyond vanilla Java 1.21.6.

## 1.0.0

Initial local implementation: inline-macro builder, non-OP trigger routing, player isolation, fresh tickets, catalogs/history/refresh, numeric/wizard forms, native notice/confirmation, TTL/reload invalidation, and 28 local integration checks. This historical entry does not imply a public GitHub release existed.
