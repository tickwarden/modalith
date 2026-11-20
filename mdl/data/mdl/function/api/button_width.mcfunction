# Resize the most recently appended action button; call before show/notice/confirmation.
$data modify storage mdl:width args set value {width:$(width)}
execute store result score #width mdl.tmp run data get storage mdl:width args.width
execute unless score #width mdl.tmp matches 1..1024 run return run function mdl:internal/diagnostic/error {code:"E_WIDTH_RANGE",source:"mdl:api/button_width"}
execute store result storage mdl:width check.width int 1 run scoreboard players get #width mdl.tmp
execute store result score #width_type mdl.tmp run data modify storage mdl:width check.width set from storage mdl:width args.width
execute if score #width_type mdl.tmp matches 1 run return run function mdl:internal/diagnostic/error {code:"E_WIDTH_TYPE",source:"mdl:api/button_width"}
execute unless data storage mdl:work dialog.actions[-1] run return run function mdl:internal/diagnostic/error {code:"E_NO_BUTTON",source:"mdl:api/button_width"}
data modify storage mdl:work dialog.actions[-1].width set from storage mdl:width args.width
return 1
