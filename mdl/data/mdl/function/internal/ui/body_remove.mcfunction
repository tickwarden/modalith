$execute unless data storage mdl:work dialog.body[$(index)] run return run function mdl:internal/diagnostic/error {code:"E_BODY_INDEX",source:"mdl:api/body_remove"}
$data remove storage mdl:work dialog.body[$(index)]
return 1
