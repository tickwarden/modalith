scoreboard players add #hook_before_action mdl.tmp 1
execute if data storage mdl:action action{cancel_test:1b} run data modify storage mdl:action cancelled set value 1b
