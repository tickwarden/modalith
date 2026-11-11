# Security policy

## Supported target

Security fixes are intended for the latest Modalith 1.3.x source targeting vanilla Minecraft Java 1.21.6. There is no hosted response-time SLA and no implicit support for forks or later game versions.

## Reporting

Do not post working privilege-escalation or cross-player state exploits in public issues. Once `tickwarden/modalith` is published and private vulnerability reporting is enabled, use its **Security → Report a vulnerability** interface. That channel has not been verified to exist during source preparation. If unavailable, first ask the repository owner for a private reporting channel without including exploit details; do not invent or use an unverified contact address.

Include the affected commit/version, exact game/server build, minimal reproduction, expected/actual behavior, impact, and a sanitized test pack. Remove player data and credentials.

## Trust boundary

The client may forge its own trigger submissions. Tickets are predictable identifiers, not secrets, click attestations, or cryptographic capabilities. The router limits accepted routes to an active player's frame, applies predicates/cooldown, consumes the session, and only then runs a trusted server callback.

Integrators must still recheck permission, balance, stock, and other transaction-sensitive state in their callbacks. Raw buttons/dialogs bypass managed routing. Template keys, callback IDs, predicates, patterns, and developer storage are trusted inputs. Other privileged datapacks are not isolated adversaries.

Lifecycle hooks are synchronous observers; rendering or recursive dispatch inside them violates the documented contract. Metrics are signed counters, not audit-grade immutable records. Cooldown is not a packet flood defense. World saves do not provide transaction rollback guarantees.

Follow least privilege for production servers. Never expose the test driver or RCON publicly, never reuse its example password, and never run the integration fixture pack in production.

Live-view renderers run on a server timer, not a newly accepted player request. Keep them display-only; do not award items, debit accounts, or push history on each render. Inputs are excluded, and timer refresh preserves original TTL. Local client dismissal is not universally observable, so provide a routed exit.

Themes, locales, state keys and dictionaries are trusted developer-controlled inputs; do not interpolate arbitrary player text into these APIs. Notification display is explicit and acknowledgements consume ordinary routes; queues are not guaranteed message delivery. Numeric form rules strengthen input validation but do not replace transaction checks. Stable rank sorting is bounded to 64 records to limit synchronous work.
