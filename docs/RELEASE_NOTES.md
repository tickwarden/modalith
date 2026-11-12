# Modalith 2.1.0

Minecraft Java 1.21.6, pack format 80. Six additive runtime features: stop-on-failure, delayed callbacks, predicate branches, disabled buttons with server route gating, exact-token catalog filtering and persistent player favorites.

Demo: `mdl_demo:demo/runtime`. See docs/RUNTIME_FEATURES.md for API examples and honest limits. Existing 2.0 callback arrays remain valid; the 1.x-to-2.0 migration requirements still apply.

Local validation: 178/178 vanilla integration assertions and 10/10 unit tests pass; 212 functions, zero static dialog registry JSON. Protocol/codec testing is not manual graphical QA. The main production pack excludes test fixtures and the optional action-hook example companion pack.

Delayed jobs are capped at one per player, count online ticks, and are invalidated by reload. Filters match exact server-owned tags rather than substrings. Favorites are bounded snapshots, not inventory or a database. Stop-on-failure does not undo earlier effects.
