# Replace the last action label with a complete text component before conversion/show.
execute unless data storage mdl:work dialog.actions[-1] run return 0
$data modify storage mdl:work dialog.actions[-1].label set value $(label)
return 1
