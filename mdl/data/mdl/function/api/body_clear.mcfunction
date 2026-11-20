execute unless data storage mdl:work dialog run return run function mdl:internal/diagnostic/error {code:"E_NO_DRAFT",source:"mdl:api/body_clear"}
data modify storage mdl:work dialog.body set value []
return 1
