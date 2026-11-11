execute unless data storage mdl:sort remaining[0] run return 0
data modify storage mdl:sort scan set from storage mdl:sort remaining
scoreboard players set #sort_index mdl.tmp 0
scoreboard players set #sort_best mdl.tmp 0
scoreboard players set #sort_rank mdl.tmp 0
execute if data storage mdl:sort remaining[0].rank store result score #sort_rank mdl.tmp run data get storage mdl:sort remaining[0].rank
function mdl:internal/sort_scan
execute store result storage mdl:sort pick.index int 1 run scoreboard players get #sort_best mdl.tmp
function mdl:internal/sort_pick with storage mdl:sort pick
function mdl:internal/sort_outer
