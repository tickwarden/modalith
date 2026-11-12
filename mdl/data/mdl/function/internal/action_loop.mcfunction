execute unless data storage mdl:dispatch stack[-1].pending[0] run return 1
data modify storage mdl:dispatch stack[-1].current set from storage mdl:dispatch stack[-1].pending[0]
data remove storage mdl:dispatch stack[-1].pending[0]
data modify storage mdl:action action set from storage mdl:dispatch stack[-1].current
data modify storage mdl:action payload set from storage mdl:dispatch stack[-1].payload
execute if data storage mdl:action action.payload run data modify storage mdl:action payload set from storage mdl:action action.payload
data modify storage mdl:action index set from storage mdl:dispatch stack[-1].index
data modify storage mdl:action cancelled set value 0b
data modify storage mdl:action result set value 0
data modify storage mdl:dispatch stack[-1].result set value 0
function mdl:internal/event_context
function #mdl:before_action
# Observers may cancel but cannot replace the trusted queued action.
execute store result score #cancel mdl.tmp run data get storage mdl:action cancelled
execute store result storage mdl:dispatch stack[-1].cancelled byte 1 run scoreboard players get #cancel mdl.tmp
data modify storage mdl:action action set from storage mdl:dispatch stack[-1].current
data modify storage mdl:action payload set from storage mdl:dispatch stack[-1].payload
execute if data storage mdl:action action.payload run data modify storage mdl:action payload set from storage mdl:action action.payload
execute unless score #cancel mdl.tmp matches 1 run function mdl:internal/action_execute
# Restore action metadata after nested callback chains.
data modify storage mdl:action action set from storage mdl:dispatch stack[-1].current
data modify storage mdl:action index set from storage mdl:dispatch stack[-1].index
data modify storage mdl:action result set from storage mdl:dispatch stack[-1].result
function mdl:internal/event_context
data modify storage mdl:action cancelled set from storage mdl:dispatch stack[-1].cancelled
data modify storage mdl:action payload set from storage mdl:dispatch stack[-1].payload
execute if data storage mdl:action action.payload run data modify storage mdl:action payload set from storage mdl:action action.payload
function #mdl:after_action
execute store result score #action_result mdl.tmp run data get storage mdl:dispatch stack[-1].result
execute if data storage mdl:dispatch stack[-1].current{stop_on_failure:1b} if score #action_result mdl.tmp matches 0 run return 0
execute store result score #index mdl.tmp run data get storage mdl:dispatch stack[-1].index
scoreboard players add #index mdl.tmp 1
execute store result storage mdl:dispatch stack[-1].index int 1 run scoreboard players get #index mdl.tmp
execute if score #index mdl.tmp matches 64.. run return 0
return run function mdl:internal/action_loop
