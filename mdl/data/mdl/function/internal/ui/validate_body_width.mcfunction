data modify storage mdl:ui number set from storage mdl:validation queue[0].width
execute store result score #validate_width mdl.tmp run function mdl:internal/ui/integer {min:1,max:1024}
execute unless score #validate_width mdl.tmp matches 1 run scoreboard players set #validate_body mdl.tmp 0
