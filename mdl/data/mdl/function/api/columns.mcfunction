$data modify storage mdl:layout args set value {columns:$(columns)}
execute store result score #columns mdl.tmp run data get storage mdl:layout args.columns
execute unless score #columns mdl.tmp matches 1..8 run return run function mdl:internal/diagnostic/error {code:"E_COLUMNS_RANGE",source:"mdl:api/columns"}
execute store result storage mdl:layout check int 1 run scoreboard players get #columns mdl.tmp
execute store result score #columns_type mdl.tmp run data modify storage mdl:layout check set from storage mdl:layout args.columns
execute if score #columns_type mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_COLUMNS_TYPE",source:"mdl:api/columns"}
execute unless data storage mdl:work dialog{type:"minecraft:multi_action"} run return run function mdl:internal/diagnostic/error {code:"E_DIALOG_TYPE",source:"mdl:api/columns"}
data modify storage mdl:work dialog.columns set from storage mdl:layout args.columns
return 1
