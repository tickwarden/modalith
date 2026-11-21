$data modify storage mdl:widget args set value {title:$(title),events:$(events),width:$(width)}
execute store result score #widget_ok mdl.tmp run function mdl:internal/widget/width
execute unless score #widget_ok mdl.tmp matches 1 run return 0
execute unless data storage mdl:widget args.title{} run return run function mdl:internal/diagnostic/error {code:"E_UI_COMPONENT",source:"mdl:api/widget/timeline"}
data modify storage mdl:widget probe set from storage mdl:widget args.events
execute store success score #widget_list mdl.tmp run data modify storage mdl:widget probe append value {}
execute unless score #widget_list mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_LIST",source:"mdl:api/widget/timeline"}
execute store result score #widget_count mdl.tmp run data get storage mdl:widget args.events
execute unless score #widget_count mdl.tmp matches 0..32 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_ROWS_LIMIT",source:"mdl:api/widget/timeline"}
$data modify storage mdl:widget result set value {text:"",extra:[$(title)]}
data modify storage mdl:widget queue set from storage mdl:widget args.events
scoreboard players set #widget_valid mdl.tmp 1
function mdl:internal/widget/timeline
execute unless score #widget_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_WIDGET_ROW",source:"mdl:api/widget/timeline"}
return run function mdl:internal/widget/emit
