execute unless score #skip mdl.tmp matches 1.. run return 0
data remove storage mdl:catalog queue[0]
scoreboard players remove #skip mdl.tmp 1
function mdl:internal/catalog_skip
