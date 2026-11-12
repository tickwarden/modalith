$data modify storage mdl:work dialog.actions append value {label:$(label),action:{type:"minecraft:dynamic/run_command",template:"/trigger mdl.input set $(ticket)$(suffix)"}}
execute store result score #button_index mdl.tmp run data get storage mdl:work dialog.actions
scoreboard players remove #button_index mdl.tmp 1
execute store result storage mdl:work form.action_index int 1 run scoreboard players get #button_index mdl.tmp
