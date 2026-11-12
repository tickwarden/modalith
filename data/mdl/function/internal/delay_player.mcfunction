$execute unless data storage mdl:db players.p$(id).delayed run return 0
$execute store result score #delay_epoch mdl.tmp run data get storage mdl:db players.p$(id).delayed.epoch
execute unless score #delay_epoch mdl.tmp = #epoch mdl.sys run return run function mdl:internal/delay_cancel with storage mdl:ctx
$execute store result score #delay mdl.tmp run data get storage mdl:db players.p$(id).delayed.ticks
scoreboard players remove #delay mdl.tmp 1
$execute store result storage mdl:db players.p$(id).delayed.ticks int 1 run scoreboard players get #delay mdl.tmp
execute if score #delay mdl.tmp matches 1.. run return 0
$data modify storage mdl:delay ready set from storage mdl:db players.p$(id).delayed
$data remove storage mdl:db players.p$(id).delayed
return run function mdl:internal/callback with storage mdl:delay ready
