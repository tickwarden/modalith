# Whole-component substitution preserves rich tooltips and quoting.
execute unless data storage mdl:work dialog.actions[-1] run return run function mdl:internal/diagnostic/error {code:"E_NO_BUTTON",source:"mdl:api/button_tooltip"}
$data modify storage mdl:work dialog.actions[-1].tooltip set value $(text)
return 1
