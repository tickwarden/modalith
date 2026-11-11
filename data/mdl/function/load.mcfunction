scoreboard objectives add mdl.id dummy
scoreboard objectives add mdl.sys dummy
scoreboard objectives add mdl.click trigger
scoreboard objectives add mdl.input trigger
scoreboard objectives add mdl.open trigger
scoreboard objectives add mdl.ttl dummy
scoreboard objectives add mdl.tmp dummy
scoreboard objectives add mdl.leave minecraft.custom:minecraft.leave_game
scoreboard objectives add mdl.seen dummy
scoreboard objectives add mdl.epoch dummy
scoreboard objectives add mdl.interval dummy
scoreboard objectives add mdl.refresh dummy
scoreboard objectives add mdl.demo dummy
scoreboard objectives add mdl.cool dummy
scoreboard objectives add mdl.stat dummy
scoreboard objectives add mdl.shown dummy
scoreboard objectives add mdl.accept dummy
scoreboard objectives add mdl.reject dummy
scoreboard objectives add mdl.expire dummy
scoreboard players add #epoch mdl.sys 1
scoreboard players add #id mdl.sys 0
scoreboard players add #ticket mdl.sys 0
scoreboard players set #ten mdl.sys 10
execute unless data storage mdl:db players run data modify storage mdl:db players set value {}
execute unless data storage mdl:config ttl run data modify storage mdl:config ttl set value 1200
execute unless data storage mdl:config cooldown run data modify storage mdl:config cooldown set value 4
scoreboard players add #shown mdl.stat 0
scoreboard players add #accepted mdl.stat 0
scoreboard players add #rejected mdl.stat 0
scoreboard players add #expired mdl.stat 0
execute unless data storage mdl:config fallback_locale run data modify storage mdl:config fallback_locale set value "en_us"
tag @a remove mdl.active
tag @a remove mdl.form
execute as @a run function mdl:internal/invalidate
scoreboard players set @a mdl.open 0
scoreboard players enable @a mdl.open
tellraw @a {text:"[Modalith] 1.3.0 loaded. /trigger mdl.open",color:"aqua"}
data modify storage mdl:dispatch stack set value []
