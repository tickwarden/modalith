execute as @a unless score @s mdl.id matches 1.. run function mdl:internal/identify
execute as @a unless score @s mdl.epoch = #epoch mdl.sys run function mdl:internal/rejoin
execute as @a unless score @s mdl.seen = @s mdl.leave run function mdl:internal/rejoin
execute as @a[scores={mdl.cool=1..}] run scoreboard players remove @s mdl.cool 1
execute as @a[tag=mdl.active] run scoreboard players remove @s mdl.ttl 1
execute as @a[tag=mdl.active,scores={mdl.interval=5..,mdl.refresh=1..}] run scoreboard players remove @s mdl.refresh 1
execute as @a[tag=mdl.active,scores={mdl.ttl=..0}] run function mdl:internal/expired
execute as @a[tag=mdl.active,scores={mdl.click=1..}] at @s run function mdl:internal/click
execute as @a[tag=mdl.active,tag=mdl.form,scores={mdl.input=1..}] at @s run function mdl:internal/input
execute as @a[scores={mdl.open=1..}] at @s run function mdl:demo/home
scoreboard players set @a mdl.open 0
scoreboard players enable @a mdl.open
execute as @a[tag=mdl.active,scores={mdl.interval=5..,mdl.refresh=..0}] at @s run function mdl:internal/auto_refresh
