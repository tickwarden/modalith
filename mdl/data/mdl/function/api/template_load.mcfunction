# Clones a trusted template into this player's draft, reissuing every ticket.
$execute unless data storage mdl:templates entries.$(key) run return 0
$data modify storage mdl:template source set from storage mdl:templates entries.$(key)
execute if data storage mdl:template source{notification:1b} run return 0
function mdl:api/begin
data modify storage mdl:work dialog set from storage mdl:template source.dialog
data modify storage mdl:work form set from storage mdl:template source.form
data modify storage mdl:work view set from storage mdl:template source.view
data modify storage mdl:work catalog set from storage mdl:template source.catalog
execute if data storage mdl:template source.progress_style run data modify storage mdl:work progress_style set from storage mdl:template source.progress_style
execute if data storage mdl:template source.refresh run data modify storage mdl:work refresh set from storage mdl:template source.refresh
execute if data storage mdl:template source.theme run data modify storage mdl:work theme set from storage mdl:template source.theme
execute if data storage mdl:template source.disabled_last run data modify storage mdl:work disabled_last set from storage mdl:template source.disabled_last
# Notification markers are intentionally not cloned; queued acknowledgements are not reusable templates.
data modify storage mdl:template queue set from storage mdl:template source.routes
scoreboard players set #template_ok mdl.tmp 1
function mdl:internal/template_routes
execute unless score #template_ok mdl.tmp matches 1 run return 0
execute if data storage mdl:work form.callback run function mdl:internal/template_form
execute unless score #template_ok mdl.tmp matches 1 run return 0
return 1
