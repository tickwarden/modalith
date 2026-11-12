execute store result score #depth mdl.tmp run data get storage mdl:db players.p$(id).history
execute if score #depth mdl.tmp matches 16.. run return 0
$execute unless data storage mdl:db players.p$(id).view.callback run return 0
$data modify storage mdl:nav entry set from storage mdl:db players.p$(id).view
$data modify storage mdl:nav entry.catalog set from storage mdl:db players.p$(id).catalog
$data modify storage mdl:db players.p$(id).history append from storage mdl:nav entry
