$data modify storage mdl:ui args set value {index:$(index),text:$(text),width:$(width)}
execute unless data storage mdl:work dialog run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/body_set"}
data modify storage mdl:ui number set from storage mdl:ui args.index
execute store result score #ui_valid mdl.tmp run function mdl:internal/ui/integer {min:0,max:2147483647}
execute unless score #ui_valid mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_UI_INTEGER",source:"mdl:api/body_set"}
return run function mdl:internal/ui/body_set with storage mdl:ui args
