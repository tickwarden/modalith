execute unless data storage mdl:work dialog{} run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/validate"}
execute unless data storage mdl:work dialog.title{} run return run function mdl:internal/diagnostic/error {code:"E_VALIDATE_TITLE",source:"mdl:api/validate"}
execute unless data storage mdl:work dialog{type:"minecraft:multi_action"} unless data storage mdl:work dialog{type:"minecraft:notice"} unless data storage mdl:work dialog{type:"minecraft:confirmation"} run return run function mdl:internal/diagnostic/error {code:"E_DIALOG_TYPE",source:"mdl:api/validate"}
execute if data storage mdl:work dialog{type:"minecraft:multi_action"} unless data storage mdl:work dialog.actions[0] run return run function mdl:internal/diagnostic/error {code:"E_VALIDATE_ACTIONS",source:"mdl:api/validate"}
execute if data storage mdl:work dialog{type:"minecraft:confirmation"} unless data storage mdl:work dialog.yes{} run return run function mdl:internal/diagnostic/error {code:"E_VALIDATE_ACTIONS",source:"mdl:api/validate"}
execute if data storage mdl:work dialog{type:"minecraft:confirmation"} unless data storage mdl:work dialog.no{} run return run function mdl:internal/diagnostic/error {code:"E_VALIDATE_ACTIONS",source:"mdl:api/validate"}
execute if data storage mdl:work dialog.after_action unless data storage mdl:work dialog{after_action:"close"} unless data storage mdl:work dialog{after_action:"none"} unless data storage mdl:work dialog{after_action:"wait_for_response"} run return run function mdl:internal/diagnostic/error {code:"E_AFTER_ACTION_VALUE",source:"mdl:api/validate"}
execute if data storage mdl:work dialog.pause unless data storage mdl:work dialog{pause:0b} unless data storage mdl:work dialog{pause:1b} run return run function mdl:internal/diagnostic/error {code:"E_UI_BOOLEAN",source:"mdl:api/validate"}
execute if data storage mdl:work dialog.can_close_with_escape unless data storage mdl:work dialog{can_close_with_escape:0b} unless data storage mdl:work dialog{can_close_with_escape:1b} run return run function mdl:internal/diagnostic/error {code:"E_UI_BOOLEAN",source:"mdl:api/validate"}
execute if data storage mdl:work dialog{pause:1b,after_action:"none"} run return run function mdl:internal/diagnostic/error {code:"E_PAUSE_AFTER_ACTION",source:"mdl:api/validate"}
execute if data storage mdl:work dialog{type:"minecraft:multi_action"} if data storage mdl:work dialog.columns run function mdl:internal/ui/validate_columns
execute if data storage mdl:work dialog{type:"minecraft:multi_action"} if data storage mdl:work dialog.columns unless score #validate_columns mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_COLUMNS_RANGE",source:"mdl:api/validate"}
data modify storage mdl:validation queue set value []
execute if data storage mdl:work dialog.body run data modify storage mdl:validation queue set from storage mdl:work dialog.body
execute store success score #validate_list mdl.tmp run data modify storage mdl:validation queue append value {}
execute unless score #validate_list mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_VALIDATE_BODY",source:"mdl:api/validate"}
data remove storage mdl:validation queue[-1]
execute store result score #validate_count mdl.tmp run data get storage mdl:validation queue
execute unless score #validate_count mdl.tmp matches 0..1024 run return run function mdl:internal/diagnostic/error {code:"E_VALIDATE_BODY_LIMIT",source:"mdl:api/validate"}
scoreboard players set #validate_body mdl.tmp 1
function mdl:internal/ui/validate_body
execute unless score #validate_body mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_VALIDATE_BODY",source:"mdl:api/validate"}
return 1
