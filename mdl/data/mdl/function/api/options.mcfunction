$data modify storage mdl:layout escape set value $(escape)
scoreboard players set #escape_valid mdl.tmp 0
execute if data storage mdl:layout {escape:0} run scoreboard players set #escape_valid mdl.tmp 1
execute if data storage mdl:layout {escape:1} run scoreboard players set #escape_valid mdl.tmp 1
execute unless score #escape_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_ESCAPE_VALUE",source:"mdl:api/options"}
$execute store result score #columns_ok mdl.tmp run function mdl:api/columns {columns:$(columns)}
execute unless score #columns_ok mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_OPTIONS_COLUMNS",source:"mdl:api/options"}
execute store result score #escape mdl.tmp run data get storage mdl:layout escape
execute store result storage mdl:work dialog.can_close_with_escape byte 1 run scoreboard players get #escape mdl.tmp
return 1
