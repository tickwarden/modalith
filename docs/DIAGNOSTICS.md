# Diagnostics (2.4.0)

Diagnostics are server-global, bounded developer records, not player notifications.

```mcfunction
function mdl:api/diagnostics_enabled {enabled:1}
function mdl:api/diagnostics
data get storage mdl:diagnostics snapshot
function mdl:api/diagnostics_clear
function mdl:api/diagnostics_enabled {enabled:0}
```

`mdl:log` stores `enabled`, `records`, `last`, and `counts.error` / `counts.warning`.
Only the last 32 records remain; counters saturate at 2147483647. Each record
contains only fixed `severity`, `code`, and `source` strings. Instrumented APIs
retain failure returns. Disabling logging does not disable validation. Clear
resets records/counters and removes the last record and exported snapshot.
No automatic chat/console output, identities, IPs, UUIDs, tickets or caller payloads
are included. Server operators can read shared storage: this is not per-user isolation.

Covered paths include layout/width validation, draft-dependent setters, composite
widget schemas, show failures, rejected dispatch, unknown action types and stopped
action sequences. A failure can produce multiple records as it propagates; counters
count reports, not unique incidents. Existing uninstrumented APIs may return failure
without a diagnostic. This is not a universal Minecraft exception handler.

Missing macro arguments, malformed interpolation and command parsing errors can be
rejected by Minecraft before a function body executes. They cannot reliably be
converted into these records. Follow documented macro schemas; this system is not
an arbitrary-untrusted-NBT sandbox. Internal diagnostic functions are implementation
details, not an untrusted caller API. Vanilla/plugin logs are separate and may contain
sensitive data even when `log-ips=false` is configured.
