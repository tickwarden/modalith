execute unless data storage mdl:event route.rules run return 1
execute store result score #rule_step mdl.tmp run data get storage mdl:event route.rules.step
execute store result score #rule_offset mdl.tmp run data get storage mdl:event route.rules.offset
execute unless score #rule_step mdl.tmp matches 1..1000000 run return 0
scoreboard players operation #rule_rem mdl.tmp = #digit mdl.tmp
scoreboard players operation #rule_rem mdl.tmp -= #rule_offset mdl.tmp
scoreboard players operation #rule_rem mdl.tmp %= #rule_step mdl.tmp
execute unless score #rule_rem mdl.tmp matches 0 run return 0
execute unless data storage mdl:event route.rules.allowed[0] run return 1
execute store result storage mdl:rules check.value int 1 run scoreboard players get #digit mdl.tmp
return run function mdl:internal/form_allowed with storage mdl:rules check
