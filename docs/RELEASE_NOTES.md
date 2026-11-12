# Modalith 2.2.0

Six requested changes:

1. Minecraft Java 26.3 / Java 25 / datapack version 121.0 migration.
2. Last-button label setter.
3. Draft body clear API.
4. Whole-component button tooltips.
5. Validated 1–8 columns setter.
6. Configurable close/none/wait_for_response after_action.

Core and optional demo remain separate. Predicates use the 26.3 type discriminator. See docs/UI_CONTROLS.md for signatures, limits and migration.

Validation: 35/35 real vanilla 26.3 server RCON/codec checks. Full player/session integration and manual graphical QA are not claimed. Pinned protocol fixtures lack a 26.3 schema; earlier 178-assertion 1.21.6 results remain historical evidence only. PR CI runs static/unit/build/checksum checks, not the server suite.
