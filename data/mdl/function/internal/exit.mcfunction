$data modify storage mdl:work dialog.exit_action set value {label:$(label),action:{type:"minecraft:run_command",command:"/trigger mdl.click set $(ticket)"}}
data modify storage mdl:work routes append from storage mdl:work route
