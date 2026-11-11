# Native client button action. No server callback ticket is allocated.
$data modify storage mdl:work dialog.actions append value {label:$(label),width:150,action:{type:"minecraft:copy_to_clipboard",value:"$(value)"}}
execute if data storage mdl:work theme.button run data modify storage mdl:work dialog.actions[-1].label merge from storage mdl:work theme.button
execute if data storage mdl:work theme.button_width run data modify storage mdl:work dialog.actions[-1].width set from storage mdl:work theme.button_width
return 1
