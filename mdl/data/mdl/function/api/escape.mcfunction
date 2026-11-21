$data modify storage mdl:ui args set value {enabled:$(enabled)}
execute unless data storage mdl:work dialog run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/escape"}
execute unless data storage mdl:ui args{enabled:0} unless data storage mdl:ui args{enabled:1} unless data storage mdl:ui args{enabled:0b} unless data storage mdl:ui args{enabled:1b} run return run function mdl:internal/diagnostic/error {code:"E_UI_BOOLEAN",source:"mdl:api/escape"}
execute store result score #ui_bool mdl.tmp run data get storage mdl:ui args.enabled
execute store result storage mdl:work dialog.can_close_with_escape byte 1 run scoreboard players get #ui_bool mdl.tmp
return 1
