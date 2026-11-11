# Modalith 2.0.0

Minecraft Java 1.21.6, datapack format 80. No static dialog registry files.

## Breaking changes

- Callback fields are typed arrays instead of strings, including views, numeric forms and catalog entries.
- Examples and demo predicate moved to `mdl_demo` namespace. Rebuild stored 1.x templates/renderers.
- See [the migration and actions guide](ACTIONS.md) before upgrading.

## Added

- Eight action entry points: run_command, open_url, suggest_command, copy_to_clipboard, show_dialog, function, close and refresh.
- Ordered server callback chains with nested queue snapshots, a 64-entry execution cap and 16-chain depth cap.
- Native client buttons remain distinct from privileged server chains; vanilla does not batch several client actions from one button.
- before_action/after_action observer tags with cancellation, action index, effective payload and integer result.
- A multi-action/native-button showcase in `mdl_demo:demo/actions`.

Local vanilla integration and release unit results are recorded in TEST_RESULTS.json and tests/run-metadata.json. Native action codec validation is not a claim of manual graphical/browser testing. Earlier progress, refresh, state, localization, themes, queues and validation features remain available through the migrated API.
