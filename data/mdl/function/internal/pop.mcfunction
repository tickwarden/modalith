$data modify storage mdl:nav target set from storage mdl:db players.p$(id).history[-1]
$data remove storage mdl:db players.p$(id).history[-1]
$execute if data storage mdl:nav target.catalog.items run data modify storage mdl:db players.p$(id).catalog set from storage mdl:nav target.catalog
