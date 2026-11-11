function mdl:api/auto_refresh_stop
execute unless data storage mdl:work view.callback run return 0
execute if data storage mdl:work dialog.inputs[0] run return 0
execute unless data storage mdl:work refresh.interval run return 0
execute store result score #refresh_ticks mdl.tmp run data get storage mdl:work refresh.interval
execute unless score #refresh_ticks mdl.tmp matches 5..1200 run return 0
scoreboard players operation @s mdl.interval = #refresh_ticks mdl.tmp
scoreboard players operation @s mdl.refresh = #refresh_ticks mdl.tmp
