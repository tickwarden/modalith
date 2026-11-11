$data modify storage mdl:work route set value {label:$(label),callback:"$(callback)",payload:$(payload)}
execute store result score #ok mdl.tmp run function mdl:internal/ticket
execute unless score #ok mdl.tmp matches 1 run return 0
function mdl:internal/exit with storage mdl:work route
