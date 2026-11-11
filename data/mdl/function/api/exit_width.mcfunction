# Resize an existing multi-action exit button before show.
$data modify storage mdl:width args set value {width:$(width)}
execute store result score #width mdl.tmp run data get storage mdl:width args.width
execute unless score #width mdl.tmp matches 1..1024 run return 0
execute store result storage mdl:width check.width int 1 run scoreboard players get #width mdl.tmp
execute store result score #width_type mdl.tmp run data modify storage mdl:width check.width set from storage mdl:width args.width
execute if score #width_type mdl.tmp matches 1 run return 0
execute unless data storage mdl:work dialog.exit_action run return 0
data modify storage mdl:work dialog.exit_action.width set from storage mdl:width args.width
return 1
