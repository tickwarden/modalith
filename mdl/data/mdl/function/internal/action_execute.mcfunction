data modify storage mdl:dispatch stack[-1].result set value 0
execute if data storage mdl:dispatch stack[-1].current{type:"function"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:internal/action_function with storage mdl:action
execute if data storage mdl:dispatch stack[-1].current{type:"run_command"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:action/run_command with storage mdl:dispatch stack[-1].current
execute if data storage mdl:dispatch stack[-1].current{type:"close"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:action/close
execute if data storage mdl:dispatch stack[-1].current{type:"refresh"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:action/refresh
execute if data storage mdl:dispatch stack[-1].current{type:"delay"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:internal/action_delay
execute if data storage mdl:dispatch stack[-1].current{type:"conditional"} store result storage mdl:dispatch stack[-1].result int 1 run function mdl:internal/action_conditional
