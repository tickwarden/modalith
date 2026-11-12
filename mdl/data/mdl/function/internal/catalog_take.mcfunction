execute unless score #left mdl.tmp matches 1.. run return 0
execute unless data storage mdl:catalog queue[0] run return 0
function mdl:api/button with storage mdl:catalog queue[0]
data remove storage mdl:catalog queue[0]
scoreboard players remove #left mdl.tmp 1
function mdl:internal/catalog_take
