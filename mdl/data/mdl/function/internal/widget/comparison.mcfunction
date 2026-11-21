execute unless data storage mdl:widget queue[0] run return 1
execute unless data storage mdl:widget queue[0].label{} run scoreboard players set #widget_valid mdl.tmp 0
execute unless data storage mdl:widget queue[0].left{} run scoreboard players set #widget_valid mdl.tmp 0
execute unless data storage mdl:widget queue[0].right{} run scoreboard players set #widget_valid mdl.tmp 0
execute unless score #widget_valid mdl.tmp matches 1 run return 0
function mdl:internal/widget/comparison_row with storage mdl:widget queue[0]
data remove storage mdl:widget queue[0]
return run function mdl:internal/widget/comparison
