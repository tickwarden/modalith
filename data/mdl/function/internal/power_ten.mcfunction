execute unless score #digits mdl.tmp matches 1.. run return 0
scoreboard players operation #factor mdl.tmp *= #ten mdl.sys
scoreboard players remove #digits mdl.tmp 1
function mdl:internal/power_ten
