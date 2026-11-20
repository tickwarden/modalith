data modify storage mdl:dispatch stack[-1].result set value 0
execute if data storage mdl:dispatch stack[-1].current{type:"function"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:internal/action_function with storage mdl:action
execute if data storage mdl:dispatch stack[-1].current{type:"run_command"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:action/run_command with storage mdl:dispatch stack[-1].current
execute if data storage mdl:dispatch stack[-1].current{type:"close"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:action/close
execute if data storage mdl:dispatch stack[-1].current{type:"refresh"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:action/refresh
execute if data storage mdl:dispatch stack[-1].current{type:"delay"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:internal/action_delay
execute if data storage mdl:dispatch stack[-1].current{type:"conditional"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:internal/action_conditional
scoreboard players set #diag_known mdl.tmp 0
execute if data storage mdl:dispatch stack[-1].current{type:"function"} run scoreboard players set #diag_known mdl.tmp 1
execute if data storage mdl:dispatch stack[-1].current{type:"run_command"} run scoreboard players set #diag_known mdl.tmp 1
execute if data storage mdl:dispatch stack[-1].current{type:"close"} run scoreboard players set #diag_known mdl.tmp 1
execute if data storage mdl:dispatch stack[-1].current{type:"refresh"} run scoreboard players set #diag_known mdl.tmp 1
execute if data storage mdl:dispatch stack[-1].current{type:"delay"} run scoreboard players set #diag_known mdl.tmp 1
execute if data storage mdl:dispatch stack[-1].current{type:"conditional"} run scoreboard players set #diag_known mdl.tmp 1
execute unless score #diag_known mdl.tmp matches 1 run function mdl:internal/diagnostic/warning {code:"W_UNKNOWN_ACTION",source:"mdl:internal/action_execute"}
