$data modify storage mdl:widget args set value {title:$(title),steps:$(steps),current:$(current),width:$(width)}
execute store result score #widget_ok mdl.tmp run function mdl:internal/widget/width
execute unless score #widget_ok mdl.tmp matches 1 run return 0
execute store result score #widget_count mdl.tmp run data get storage mdl:widget args.steps
execute unless score #widget_count mdl.tmp matches 1..16 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_STEPS_LIMIT",source:"mdl:api/widget/step_indicator"}
execute store result score #widget_current mdl.tmp run data get storage mdl:widget args.current
execute unless score #widget_current mdl.tmp matches 1..16 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_POSITION",source:"mdl:api/widget/step_indicator"}
execute if score #widget_current mdl.tmp > #widget_count mdl.tmp run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_POSITION",source:"mdl:api/widget/step_indicator"}
execute store result storage mdl:widget current_check int 1 run scoreboard players get #widget_current mdl.tmp
execute store result score #widget_type mdl.tmp run data modify storage mdl:widget current_check set from storage mdl:widget args.current
execute if score #widget_type mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_POSITION_TYPE",source:"mdl:api/widget/step_indicator"}
$data modify storage mdl:widget result set value {text:"",extra:[$(title)]}
data modify storage mdl:widget queue set from storage mdl:widget args.steps
scoreboard players set #widget_index mdl.tmp 1
scoreboard players set #widget_valid mdl.tmp 1
function mdl:internal/widget/step_indicator
execute unless score #widget_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_ROW",source:"mdl:api/widget/step_indicator"}
return run function mdl:internal/widget/emit
