$execute unless data storage mdl:work dialog.body[$(index)] run return run function mdl:internal/diagnostic/error {code:"E_BODY_INDEX",source:"mdl:api/body_set"}
$data modify storage mdl:ui target set from storage mdl:work dialog.body[$(index)]
execute unless data storage mdl:ui target{type:"minecraft:plain_message"} run return run function mdl:internal/diagnostic/error {code:"E_BODY_NOT_TEXT",source:"mdl:api/body_set"}
execute unless data storage mdl:ui args.text{} run return run function mdl:internal/diagnostic/error {code:"E_UI_COMPONENT",source:"mdl:api/body_set"}
data modify storage mdl:ui number set from storage mdl:ui args.width
execute store result score #ui_valid mdl.tmp run function mdl:internal/ui/integer {min:1,max:1024}
execute unless score #ui_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_UI_INTEGER",source:"mdl:api/body_set"}
$data modify storage mdl:ui replacement set value {type:"minecraft:plain_message",contents:$(text),width:$(width)}
execute if data storage mdl:work theme.body run data modify storage mdl:ui replacement.contents merge from storage mdl:work theme.body
$data modify storage mdl:work dialog.body[$(index)] set from storage mdl:ui replacement
return 1
