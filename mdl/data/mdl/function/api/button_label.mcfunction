# Replace the last action label with a complete text component before conversion/show.
execute unless data storage mdl:work dialog.actions[-1] run return run function mdl:internal/diagnostic/error {code:"E_NO_BUTTON",source:"mdl:api/button_label"}
$data modify storage mdl:work dialog.actions[-1].label set value $(label)
return 1
