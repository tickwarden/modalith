scoreboard players add @s mdl.leave 0
scoreboard players operation @s mdl.seen = @s mdl.leave
function mdl:internal/invalidate
scoreboard players operation @s mdl.epoch = #epoch mdl.sys
scoreboard players add @s mdl.cool 0
scoreboard players add @s mdl.shown 0
scoreboard players add @s mdl.accept 0
scoreboard players add @s mdl.reject 0
scoreboard players add @s mdl.expire 0
