# Modalith 2.3.0

Minecraft Java 26.3 / Java 25 / datapack version 121.0.

Four new read-only composite widgets: stat card, key-value list, checklist and step indicator. They append ordinary plain_message body components, preserve supplied text styles, use validated width/list bounds and reject known invalid models without partial body output. No new native widget types or interactive checkbox/table controls are claimed.

API guide: docs/WIDGETS.md. Optional demo: mdl_demo:demo/widgets. Core and demo remain independent datapacks; existing 2.2 APIs remain available.

Validation: 68/68 real-server RCON/codec checks (35 previous + 33 widgets), 14/14 unit/layout tests, static lint and deterministic package/checksum checks. No manual graphical UI or end-to-end player session testing is claimed. PR CI runs static/unit/build checks, not the server suite.
