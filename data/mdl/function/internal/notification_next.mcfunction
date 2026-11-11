$execute unless data storage mdl:db players.p$(id).frame{notification:1b} run return 0
$data remove storage mdl:db players.p$(id).notifications[0]
$execute if data storage mdl:db players.p$(id).notifications[0] run return run function mdl:internal/notifications_show with storage mdl:ctx
function mdl:internal/notification_finish with storage mdl:ctx
