$data modify storage mdl:sort model set value {title:$(title),size:$(size),page:$(page),items:$(items)}
$data modify storage mdl:sort descending set value $(descending)
execute store result score #sort_count mdl.tmp run data get storage mdl:sort model.items
execute unless score #sort_count mdl.tmp matches 0..64 run return 0
execute store result score #sort_desc mdl.tmp run data get storage mdl:sort descending
execute unless score #sort_desc mdl.tmp matches 0..1 run return 0
data modify storage mdl:sort remaining set from storage mdl:sort model.items
data modify storage mdl:sort sorted set value []
function mdl:internal/sort_outer
data modify storage mdl:catalog model set from storage mdl:sort model
data modify storage mdl:catalog model.items set from storage mdl:sort sorted
function mdl:internal/catalog
