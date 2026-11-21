$data modify storage mdl:ui args set value {width:$(width)}
execute unless data storage mdl:work dialog run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/body_width"}
data modify storage mdl:ui number set from storage mdl:ui args.width
execute store result score #ui_valid mdl.tmp run function mdl:internal/ui/integer {min:1,max:1024}
execute unless score #ui_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_UI_INTEGER",source:"mdl:api/body_width"}
execute store result storage mdl:work body_width int 1 run scoreboard players get #ui_number mdl.tmp
return 1
