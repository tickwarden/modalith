# Whole-component substitution preserves rich tooltips and quoting.
execute unless data storage mdl:work dialog.actions[-1] run return 0
$data modify storage mdl:work dialog.actions[-1].tooltip set value $(text)
return 1
