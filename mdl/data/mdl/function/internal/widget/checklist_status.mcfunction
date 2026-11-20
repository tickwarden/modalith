$data modify storage mdl:widget status set value "$(status)"
execute if data storage mdl:widget {status:"done"} run data modify storage mdl:widget marker set value {text:"[x] ",color:"green"}
execute if data storage mdl:widget {status:"pending"} run data modify storage mdl:widget marker set value {text:"[ ] ",color:"gray"}
execute if data storage mdl:widget {status:"failed"} run data modify storage mdl:widget marker set value {text:"[!] ",color:"red"}
execute if data storage mdl:widget {status:"done"} run scoreboard players set #widget_status mdl.tmp 1
execute if data storage mdl:widget {status:"pending"} run scoreboard players set #widget_status mdl.tmp 1
execute if data storage mdl:widget {status:"failed"} run scoreboard players set #widget_status mdl.tmp 1
