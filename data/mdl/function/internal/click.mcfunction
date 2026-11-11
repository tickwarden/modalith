function mdl:internal/context
execute store result storage mdl:ctx ticket int 1 run scoreboard players get @s mdl.click
scoreboard players reset @s mdl.click
data remove storage mdl:event route
function mdl:internal/find_route with storage mdl:ctx
execute unless data storage mdl:event route.callback run return run function mdl:internal/reject_ticket
execute store result score #authorized mdl.tmp run function mdl:internal/authorize
execute unless score #authorized mdl.tmp matches 1 run return 0
function mdl:internal/accept
data remove storage mdl:event value
data remove storage mdl:event reason
data modify storage mdl:event type set value "click"
# Consume before callback; callback may create a new session.
function mdl:internal/invalidate
dialog clear @s
function mdl:internal/event_context
function #mdl:on_event
function mdl:internal/callback with storage mdl:event route
