$data modify storage mdl:work dialog.actions append value {label:$(label),action:{type:"minecraft:dynamic/run_command",template:"/trigger mdl.input set $(ticket)$(suffix)"}}
