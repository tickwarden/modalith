$data modify storage mdl:filter model set value {title:$(title),size:$(size),page:$(page),items:[]}
$data modify storage mdl:filter queue set value $(items)
$data modify storage mdl:filter options set value {query:"$(query)"}
execute store result score #filter_count mdl.tmp run data get storage mdl:filter queue
execute unless score #filter_count mdl.tmp matches 0..64 run return 0
function mdl:internal/filter_collect
data modify storage mdl:catalog model set from storage mdl:filter model
return run function mdl:internal/catalog
