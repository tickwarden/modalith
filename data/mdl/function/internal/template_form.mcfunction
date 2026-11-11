data modify storage mdl:template patch.old set from storage mdl:work form.ticket
data modify storage mdl:template patch.suffix set from storage mdl:work form.suffix
execute store result score #factor mdl.tmp run data get storage mdl:work form.factor
scoreboard players set #limit mdl.tmp 2147483647
scoreboard players operation #limit mdl.tmp /= #factor mdl.tmp
scoreboard players remove #limit mdl.tmp 1
execute if score #ticket mdl.sys >= #limit mdl.tmp run return run function mdl:internal/template_failed
execute store result score #ok mdl.tmp run function mdl:internal/ticket
execute unless score #ok mdl.tmp matches 1 run return run function mdl:internal/template_failed
data modify storage mdl:work form.ticket set from storage mdl:work route.ticket
data modify storage mdl:template patch.new set from storage mdl:work form.ticket
function mdl:internal/template_form_patch with storage mdl:template patch
