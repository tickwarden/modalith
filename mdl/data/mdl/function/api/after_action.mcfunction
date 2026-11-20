$data modify storage mdl:layout after set value "$(value)"
scoreboard players set #after_ok mdl.tmp 0
execute if data storage mdl:layout {after:"close"} run scoreboard players set #after_ok mdl.tmp 1
execute if data storage mdl:layout {after:"none"} run scoreboard players set #after_ok mdl.tmp 1
execute if data storage mdl:layout {after:"wait_for_response"} run scoreboard players set #after_ok mdl.tmp 1
execute unless score #after_ok mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_AFTER_ACTION_VALUE",source:"mdl:api/after_action"}
execute unless data storage mdl:work dialog run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/after_action"}
data modify storage mdl:work dialog.after_action set from storage mdl:layout after
execute if data storage mdl:layout {after:"none"} run data modify storage mdl:work dialog.pause set value 0b
return 1
