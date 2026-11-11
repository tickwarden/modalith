execute if score @s mdl.cool matches 1.. run return run function mdl:internal/reject_cooldown
scoreboard players set #allowed mdl.tmp 1
execute if data storage mdl:event route.guard run scoreboard players set #allowed mdl.tmp 0
execute if data storage mdl:event route.guard run function mdl:internal/guard with storage mdl:event route
execute unless score #allowed mdl.tmp matches 1 run return run function mdl:internal/reject_guard
return 1
