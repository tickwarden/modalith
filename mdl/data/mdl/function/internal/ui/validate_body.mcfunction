execute unless data storage mdl:validation queue[0] run return 1
data modify storage mdl:validation current set from storage mdl:validation queue[0]
execute unless data storage mdl:validation current{type:"minecraft:plain_message"} unless data storage mdl:validation current{type:"minecraft:item"} run scoreboard players set #validate_body mdl.tmp 0
execute if data storage mdl:validation current{type:"minecraft:plain_message"} unless data storage mdl:validation queue[0].contents{} run scoreboard players set #validate_body mdl.tmp 0
execute if data storage mdl:validation current{type:"minecraft:item"} unless data storage mdl:validation queue[0].item{} run scoreboard players set #validate_body mdl.tmp 0
execute if data storage mdl:validation queue[0].width run function mdl:internal/ui/validate_body_width
execute unless score #validate_body mdl.tmp matches 1 run return 0
data remove storage mdl:validation queue[0]
return run function mdl:internal/ui/validate_body
