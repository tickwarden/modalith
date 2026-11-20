execute store result score #widget_width mdl.tmp run data get storage mdl:widget args.width
execute unless score #widget_width mdl.tmp matches 1..1024 run return 0
execute store result storage mdl:widget width_check int 1 run scoreboard players get #widget_width mdl.tmp
execute store result score #widget_type mdl.tmp run data modify storage mdl:widget width_check set from storage mdl:widget args.width
execute if score #widget_type mdl.tmp matches 1 run return 0
execute unless data storage mdl:work dialog run return 0
return 1
