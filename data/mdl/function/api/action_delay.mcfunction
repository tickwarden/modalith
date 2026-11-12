$data modify storage mdl:delay args set value {ticks:$(ticks),callback:$(callback),payload:$(payload)}
execute store result score #delay mdl.tmp run data get storage mdl:delay args.ticks
execute unless score #delay mdl.tmp matches 1..1200 run return 0
execute store result storage mdl:delay check int 1 run scoreboard players get #delay mdl.tmp
execute store result score #delay_type mdl.tmp run data modify storage mdl:delay check set from storage mdl:delay args.ticks
execute if score #delay_type mdl.tmp matches 1 run return 0
function mdl:internal/context
data modify storage mdl:delay args.id set from storage mdl:ctx id
return run function mdl:internal/delay_set with storage mdl:delay args
