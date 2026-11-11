$execute unless data storage mdl:themes entries.$(key) run return 0
$data modify storage mdl:work theme set from storage mdl:themes entries.$(key)
data modify storage mdl:work dialog.columns set from storage mdl:work theme.columns
function mdl:internal/theme_title
return 1
