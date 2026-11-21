execute store result score #ui_number mdl.tmp run data get storage mdl:ui number
$execute unless score #ui_number mdl.tmp matches $(min)..$(max) run return 0
execute store result storage mdl:ui check int 1 run scoreboard players get #ui_number mdl.tmp
execute store result score #ui_type mdl.tmp run data modify storage mdl:ui check set from storage mdl:ui number
execute if score #ui_type mdl.tmp matches 1 run return 0
return 1
