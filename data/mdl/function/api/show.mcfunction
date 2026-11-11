execute unless entity @s[type=minecraft:player] run return 0
execute store result score #owner mdl.tmp run data get storage mdl:work owner
execute unless score @s mdl.id = #owner mdl.tmp run return 0
# Ensure required nonempty actions. Passive buttons use close, not waiting.
execute if data storage mdl:work dialog{type:"minecraft:multi_action"} unless data storage mdl:work dialog.actions[0] run data modify storage mdl:work dialog.actions append value {label:"Close",action:{type:"minecraft:run_command",command:"/trigger mdl.open set 1"}}
execute store success score #shown mdl.tmp run function mdl:internal/show with storage mdl:work
execute unless score #shown mdl.tmp matches 1 run return 0
function mdl:internal/context
function mdl:internal/commit with storage mdl:ctx
scoreboard players set @s mdl.click 0
scoreboard players set @s mdl.input 0
scoreboard players enable @s mdl.click
tag @s add mdl.active
tag @s remove mdl.form
execute if data storage mdl:work form.callback run tag @s add mdl.form
execute if entity @s[tag=mdl.form] run scoreboard players enable @s mdl.input
execute unless entity @s[tag=mdl.refreshing] store result score @s mdl.ttl run data get storage mdl:config ttl
function mdl:internal/auto_refresh_configure
execute if entity @s[tag=mdl.refreshing] run tag @s add mdl.refresh_done
scoreboard players add @s mdl.shown 1
scoreboard players add #shown mdl.stat 1
function mdl:internal/lifecycle
data modify storage mdl:event type set value "show"
function #mdl:on_show
return 1
