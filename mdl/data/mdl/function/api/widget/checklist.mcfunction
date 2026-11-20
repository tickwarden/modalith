$data modify storage mdl:widget args set value {title:$(title),items:$(items),width:$(width)}
execute store result score #widget_ok mdl.tmp run function mdl:internal/widget/width
execute unless score #widget_ok mdl.tmp matches 1 run return 0
execute store result score #widget_count mdl.tmp run data get storage mdl:widget args.items
execute unless score #widget_count mdl.tmp matches 0..32 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_ROWS_LIMIT",source:"mdl:api/widget/checklist"}
$data modify storage mdl:widget result set value {text:"",extra:[$(title)]}
data modify storage mdl:widget queue set from storage mdl:widget args.items
scoreboard players set #widget_valid mdl.tmp 1
function mdl:internal/widget/checklist
execute unless score #widget_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_STATUS",source:"mdl:api/widget/checklist"}
return run function mdl:internal/widget/emit
