$data modify storage mdl:refresh requested set value $(ticks)
execute store result score #refresh_ticks mdl.tmp run data get storage mdl:refresh requested
execute if score #refresh_ticks mdl.tmp matches 0 run return run function mdl:internal/auto_refresh_disable_draft
execute unless score #refresh_ticks mdl.tmp matches 5..1200 run return 0
execute unless data storage mdl:work view.callback run return 0
execute if data storage mdl:work dialog.inputs[0] run return 0
data modify storage mdl:work refresh set value {}
data modify storage mdl:work refresh.interval set from storage mdl:refresh requested
return 1
