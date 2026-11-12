scoreboard players operation #gate mdl.tmp = @s mdl.input
scoreboard players operation #digit mdl.tmp = @s mdl.input
scoreboard players reset @s mdl.input
function mdl:internal/context
function mdl:internal/get_form with storage mdl:ctx
execute store result score #factor mdl.tmp run data get storage mdl:event route.factor
execute unless score #factor mdl.tmp matches 10..1000000 run return run function mdl:internal/reject_input
scoreboard players operation #gate mdl.tmp /= #factor mdl.tmp
scoreboard players operation #digit mdl.tmp %= #factor mdl.tmp
execute store result score #expected mdl.tmp run data get storage mdl:event route.ticket
execute store result score #min mdl.tmp run data get storage mdl:event route.min
execute store result score #max mdl.tmp run data get storage mdl:event route.max
execute unless score #gate mdl.tmp = #expected mdl.tmp run return run function mdl:internal/reject_input
execute if score #digit mdl.tmp < #min mdl.tmp run return run function mdl:internal/reject_input
execute if score #digit mdl.tmp > #max mdl.tmp run return run function mdl:internal/reject_input
execute store result score #rules_ok mdl.tmp run function mdl:internal/form_rules
execute unless score #rules_ok mdl.tmp matches 1 run return run function mdl:internal/reject_validation
execute store result score #authorized mdl.tmp run function mdl:internal/authorize
execute unless score #authorized mdl.tmp matches 1 run return 0
function mdl:internal/accept
data remove storage mdl:event reason
data modify storage mdl:event type set value "input"
execute store result storage mdl:event value int 1 run scoreboard players get #digit mdl.tmp
function mdl:internal/invalidate
dialog clear @s
function mdl:internal/event_context
function #mdl:on_event
function mdl:internal/callback with storage mdl:event route
