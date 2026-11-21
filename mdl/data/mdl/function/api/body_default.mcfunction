$data modify storage mdl:ui default_body set value {text:$(text),width:300}
execute unless data storage mdl:work dialog run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/body_default"}
execute unless data storage mdl:ui default_body.text{} run return run function mdl:internal/diagnostic/error {code:"E_UI_COMPONENT",source:"mdl:api/body_default"}
execute if data storage mdl:work body_width run data modify storage mdl:ui default_body.width set from storage mdl:work body_width
return run function mdl:api/body with storage mdl:ui default_body
