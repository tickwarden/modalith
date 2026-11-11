execute unless data storage mdl:sort scan[0] run return 0
scoreboard players set #sort_candidate mdl.tmp 0
execute if data storage mdl:sort scan[0].rank store result score #sort_candidate mdl.tmp run data get storage mdl:sort scan[0].rank
execute if score #sort_desc mdl.tmp matches 0 if score #sort_candidate mdl.tmp < #sort_rank mdl.tmp run function mdl:internal/sort_better
execute if score #sort_desc mdl.tmp matches 1 if score #sort_candidate mdl.tmp > #sort_rank mdl.tmp run function mdl:internal/sort_better
scoreboard players add #sort_index mdl.tmp 1
data remove storage mdl:sort scan[0]
function mdl:internal/sort_scan
