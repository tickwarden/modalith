$data modify storage mdl:work dialog.actions append value {label:$(label),width:150,action:{type:"minecraft:run_command",command:"/trigger mdl.click set $(ticket)"}}
execute if data storage mdl:work theme.button run data modify storage mdl:work dialog.actions[-1].label merge from storage mdl:work theme.button
execute if data storage mdl:work theme.button_width run data modify storage mdl:work dialog.actions[-1].width set from storage mdl:work theme.button_width
data modify storage mdl:work routes append from storage mdl:work route
