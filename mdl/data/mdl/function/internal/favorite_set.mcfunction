$execute unless data storage mdl:db players.p$(id).favorites run data modify storage mdl:db players.p$(id).favorites set value []
$execute store result score #favorites mdl.tmp run data get storage mdl:db players.p$(id).favorites
$execute if score #favorites mdl.tmp matches 64.. unless data storage mdl:db players.p$(id).favorites[{key:"$(key)"}] run return 0
$data remove storage mdl:db players.p$(id).favorites[{key:"$(key)"}]
$data modify storage mdl:db players.p$(id).favorites append value {key:"$(key)",item:$(item)}
return 1
