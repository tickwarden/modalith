# Copy transient action data immediately. Use a player-scoped persistent record.
data modify storage mdl_example:scratch value set from storage mdl:action
data modify storage mdl_example:scratch args set value {key:"last_action"}
data modify storage mdl_example:scratch args.value set from storage mdl_example:scratch value
function mdl:api/state_set with storage mdl_example:scratch args
