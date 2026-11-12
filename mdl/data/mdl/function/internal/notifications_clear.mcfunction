$data modify storage mdl:db players.p$(id).notifications set value []
$execute if data storage mdl:db players.p$(id).frame{notification:1b} if entity @s[tag=mdl.active] run return run function mdl:internal/notification_finish with storage mdl:ctx
$data modify storage mdl:db players.p$(id).notify_open set value 0b
$data modify storage mdl:db players.p$(id).notify_return set value {}
