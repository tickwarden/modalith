$data modify storage mdl:ui args set value {text:$(text),width:$(width)}
execute unless data storage mdl:work dialog run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/body"}
execute unless data storage mdl:ui args.text{} run return run function mdl:internal/diagnostic/error {code:"E_UI_COMPONENT",source:"mdl:api/body"}
data modify storage mdl:ui number set from storage mdl:ui args.width
execute store result score #ui_valid mdl.tmp run function mdl:internal/ui/integer {min:1,max:1024}
execute unless score #ui_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_UI_INTEGER",source:"mdl:api/body"}
$data modify storage mdl:work dialog.body append value {type:"minecraft:plain_message",contents:$(text),width:$(width)}
execute if data storage mdl:work theme.body run data modify storage mdl:work dialog.body[-1].contents merge from storage mdl:work theme.body
return 1
