$data modify storage mdl:toggle args set value {enabled:$(enabled)}
execute unless data storage mdl:toggle args{enabled:0} unless data storage mdl:toggle args{enabled:1} run return 0
execute store result score #enabled mdl.tmp run data get storage mdl:toggle args.enabled
execute unless score #enabled mdl.tmp matches 0..1 run return 0
execute unless data storage mdl:work dialog.actions[-1] run return 0
execute store result score #button_index mdl.tmp run data get storage mdl:work dialog.actions
scoreboard players remove #button_index mdl.tmp 1
execute store result storage mdl:toggle args.index int 1 run scoreboard players get #button_index mdl.tmp
return run function mdl:internal/button_toggle with storage mdl:toggle args
