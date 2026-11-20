execute unless data storage mdl:widget queue[0] run return 1
execute unless data storage mdl:widget queue[0].label run scoreboard players set #widget_valid mdl.tmp 0
execute unless score #widget_valid mdl.tmp matches 1 run return 0
data modify storage mdl:widget marker set value {text:"[ ] ",color:"gray"}
execute if score #widget_index mdl.tmp < #widget_current mdl.tmp run data modify storage mdl:widget marker set value {text:"[+] ",color:"green"}
execute if score #widget_index mdl.tmp = #widget_current mdl.tmp run data modify storage mdl:widget marker set value {text:"[>] ",color:"gold",bold:1b}
function mdl:internal/widget/checklist_row with storage mdl:widget queue[0]
data remove storage mdl:widget queue[0]
scoreboard players add #widget_index mdl.tmp 1
return run function mdl:internal/widget/step_indicator
