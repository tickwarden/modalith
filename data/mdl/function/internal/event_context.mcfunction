data modify storage mdl:event player set from entity @s UUID
execute store result storage mdl:event player_id int 1 run scoreboard players get @s mdl.id
