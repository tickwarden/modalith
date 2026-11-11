$data modify storage mdl:db players.p$(id).frame set from storage mdl:work
$data modify storage mdl:db players.p$(id).view set from storage mdl:work view
$execute if data storage mdl:work catalog.items run data modify storage mdl:db players.p$(id).catalog set from storage mdl:work catalog
