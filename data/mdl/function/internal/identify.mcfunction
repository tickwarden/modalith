execute if score #id mdl.sys matches 2147483647 run return 0
scoreboard players add #id mdl.sys 1
scoreboard players operation @s mdl.id = #id mdl.sys
function mdl:internal/context
function mdl:internal/new_player with storage mdl:ctx
