data modify storage mdl:stats snapshot set value {global:{},player:{}}
function mdl:internal/event_context
execute store result storage mdl:stats snapshot.player.id int 1 run scoreboard players get @s mdl.id
execute store result storage mdl:stats snapshot.global.shown int 1 run scoreboard players get #shown mdl.stat
execute store result storage mdl:stats snapshot.player.shown int 1 run scoreboard players get @s mdl.shown
execute store result storage mdl:stats snapshot.global.accepted int 1 run scoreboard players get #accepted mdl.stat
execute store result storage mdl:stats snapshot.player.accepted int 1 run scoreboard players get @s mdl.accept
execute store result storage mdl:stats snapshot.global.rejected int 1 run scoreboard players get #rejected mdl.stat
execute store result storage mdl:stats snapshot.player.rejected int 1 run scoreboard players get @s mdl.reject
execute store result storage mdl:stats snapshot.global.expired int 1 run scoreboard players get #expired mdl.stat
execute store result storage mdl:stats snapshot.player.expired int 1 run scoreboard players get @s mdl.expire
