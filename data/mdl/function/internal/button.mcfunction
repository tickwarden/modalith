$data modify storage mdl:work dialog.actions append value {label:$(label),width:150,action:{type:"minecraft:run_command",command:"/trigger mdl.click set $(ticket)"}}
execute if data storage mdl:work theme.button run data modify storage mdl:work dialog.actions[-1].label merge from storage mdl:work theme.button
execute if data storage mdl:work theme.button_width run data modify storage mdl:work dialog.actions[-1].width set from storage mdl:work theme.button_width
execute store result score #button_index mdl.tmp run data get storage mdl:work dialog.actions
scoreboard players remove #button_index mdl.tmp 1
execute store result storage mdl:work route.action_index int 1 run scoreboard players get #button_index mdl.tmp
data modify storage mdl:work routes append from storage mdl:work route
