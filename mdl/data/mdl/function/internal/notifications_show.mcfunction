$execute unless data storage mdl:db players.p$(id).notifications[0] run return 0
$execute unless data storage mdl:db players.p$(id){notify_open:1b} run data modify storage mdl:db players.p$(id).notify_return set from storage mdl:db players.p$(id).view
$data modify storage mdl:db players.p$(id).notify_open set value 1b
$data modify storage mdl:notification current set from storage mdl:db players.p$(id).notifications[0]
function mdl:internal/notification_render with storage mdl:notification current
return 1
