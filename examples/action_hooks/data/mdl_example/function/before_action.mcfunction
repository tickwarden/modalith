# Optional integration gate: only run_command is blocked by this example tag.
# Enable for a player: /tag <player> add mdl_example.block_commands
execute if entity @s[tag=mdl_example.block_commands] if data storage mdl:action action{type:"run_command"} run data modify storage mdl:action cancelled set value 1b
