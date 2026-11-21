# Modalith 2.5.0

Minecraft Java 26.3 / Java 25 / datapack 121.0.

Nine new features: three read-only widgets (callout, comparison, timeline), three
draft settings (Escape, pause, default body width), and three tools (structural
validator, indexed body replacement and removal). The supporting `body_default`
entrypoint avoids optional macro arguments; existing valid explicit-width body
calls retain their signature. Default width resets at begin and is copied by templates.

New errors use the existing bounded diagnostics. Structural validation is not the
full native codec; widgets are ordinary text, not interactive/native new controls.
No player session, multiplayer pausing, complete input-schema validation or GUI QA
is claimed. English documentation: docs/NINE_FEATURES.md. Optional demo:
mdl_demo:demo/nine_features. Core remains independent of demo/test fixtures.

Live RCON/codec suites run in a separate Linux network namespace with loopback only,
with server shutdown in a finally block. See docs/TESTING.md for final counts/evidence.
CI runs static/unit/build checks, not the live server suites. No auto-merge.

Verified: 212/212 live RCON/codec checks (88 prior + 124 new), 32/32 unit tests,
262 functions linted with zero errors, deterministic core/demo packaging and checksums.
