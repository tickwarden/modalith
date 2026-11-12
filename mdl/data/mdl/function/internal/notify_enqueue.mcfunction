$execute unless data storage mdl:db players.p$(id).notifications run data modify storage mdl:db players.p$(id).notifications set value []
$execute store result score #notify_count mdl.tmp run data get storage mdl:db players.p$(id).notifications
execute if score #notify_count mdl.tmp matches 32.. run return 0
$data modify storage mdl:db players.p$(id).notifications append from storage mdl:notification entry
return 1
