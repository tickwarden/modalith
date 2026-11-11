# Callback must validate each field, not just combined code interval.
execute store result score #code mdl.tmp run data get storage mdl:event value
scoreboard players operation #mode mdl.tmp = #code mdl.tmp
scoreboard players operation #mode mdl.tmp %= #ten mdl.sys
scoreboard players operation #code mdl.tmp /= #ten mdl.sys
scoreboard players operation #enabled mdl.tmp = #code mdl.tmp
scoreboard players operation #enabled mdl.tmp %= #ten mdl.sys
execute unless score #mode mdl.tmp matches 0..2 run return run function mdl:demo/packed
execute unless score #enabled mdl.tmp matches 0..1 run return run function mdl:demo/packed
tellraw @s [{text:"Atomic form code: ",color:"green"},{nbt:"value",storage:"mdl:event"}]
function mdl:demo/home
