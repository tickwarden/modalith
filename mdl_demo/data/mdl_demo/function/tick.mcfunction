execute as @a[scores={mdl.open=1..}] at @s run function mdl_demo:demo/home
scoreboard players set @a mdl.open 0
scoreboard players enable @a mdl.open
