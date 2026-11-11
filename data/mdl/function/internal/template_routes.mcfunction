execute unless data storage mdl:template queue[0] run return 0
data modify storage mdl:work route set from storage mdl:template queue[0]
data modify storage mdl:template patch.old set from storage mdl:work route.ticket
execute store result score #ok mdl.tmp run function mdl:internal/ticket
execute unless score #ok mdl.tmp matches 1 run return run function mdl:internal/template_failed
data modify storage mdl:template patch.new set from storage mdl:work route.ticket
function mdl:internal/template_patch with storage mdl:template patch
data modify storage mdl:work routes append from storage mdl:work route
data remove storage mdl:template queue[0]
function mdl:internal/template_routes
